class Api::V1::CommunitiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 100].min # Ограничиваем максимум 100 записей на страницу
    
    @communities = Community.order(created_at: :desc)
                           .limit(per_page)
                           .offset((page - 1) * per_page)
    
    total_count = Community.count
    total_pages = (total_count.to_f / per_page).ceil
    
    render json: {
      communities: @communities.map { |community| community.as_json.merge(
        tags: community.tag_list
      )},
      pagination: {
        current_page: page,
        per_page: per_page,
        total_count: total_count,
        total_pages: total_pages,
        has_next_page: page < total_pages,
        has_prev_page: page > 1
      }
    }
  end

  def show
    @community = Community.find(params[:id])
  end

  # POST /api/v1/communities/:id/subscribe
  def subscribe
    begin
      user = User.find_by_jti(decrypt_payload[0]["jti"])
      
      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      @community = Community.find(params[:id])
      
      if user.subscriptions.where(subscriptionable: @community).exists?
        return render json: { error: "Already subscribed" }, status: :unprocessable_entity
      end

      subscription = user.subscriptions.create!(subscriptionable: @community)
      
      render json: {
        success: true,
        message: "Successfully subscribed to community",
        subscription: {
          id: subscription.id,
          community_id: @community.id,
          subscribed_at: subscription.created_at
        }
      }, status: :created
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Subscription failed: #{e.message}" }, status: :internal_server_error
    end
  end

  # DELETE /api/v1/communities/:id/unsubscribe
  def unsubscribe
    begin
      user = User.find_by_jti(decrypt_payload[0]["jti"])
      
      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      @community = Community.find(params[:id])
      subscription = user.subscriptions.find_by(subscriptionable: @community)
      
      unless subscription
        return render json: { error: "Not subscribed to this community" }, status: :not_found
      end

      subscription.destroy
      
      render json: {
        success: true,
        message: "Successfully unsubscribed from community"
      }
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Unsubscription failed: #{e.message}" }, status: :internal_server_error
    end
  end

  # GET /api/v1/communities/:id/subscribers
  def subscribers
    @community = Community.find(params[:id])
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 100].min
    
    subscribers = @community.subscriptions.includes(:user)
                           .order(created_at: :desc)
                           .limit(per_page)
                           .offset((page - 1) * per_page)
    
    total_count = @community.subscriptions.count
    total_pages = (total_count.to_f / per_page).ceil
    
    render json: {
      subscribers: subscribers.map { |sub| 
        user = sub.user
        {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          subscribed_at: sub.created_at
        }
      },
      pagination: {
        current_page: page,
        per_page: per_page,
        total_count: total_count,
        total_pages: total_pages,
        has_next_page: page < total_pages,
        has_prev_page: page > 1
      }
    }
  end

  private

  def decrypt_payload
    jwt = request.headers["Authorization"]
    raise "No authorization header" if jwt.blank?
    
    token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: "HS256" })
    token
  end
end
