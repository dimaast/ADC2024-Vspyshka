class Api::V1::MeetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 100].min # Ограничиваем максимум 100 записей на страницу
    
    @meets = Meet.order(created_at: :desc)
                 .limit(per_page)
                 .offset((page - 1) * per_page)
    
    total_count = Meet.count
    total_pages = (total_count.to_f / per_page).ceil
    
    render json: {
      meets: @meets.map { |meet| meet.as_json.merge(
        tags: meet.tag_list
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
    @meet = Meet.find(params[:id])
  end

  def create
    begin
      user = User.find_by_jti(decrypt_payload[0]["jti"])
      
      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      meet = user.meets.new(meet_params)

      if meet.save
        render json: meet, status: :created
      else
        render json: { errors: meet.errors.full_messages }, status: :unprocessable_entity
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
    end
  end

  def destroy
    begin
      @meet = Meet.find(params[:id])
      user = User.find_by_jti(decrypt_payload[0]["jti"])

      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      unless @meet.user == user
        return render json: { error: "Unauthorized" }, status: :unauthorized
      end

      @meet.destroy
      head :no_content
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
    end
  end

  def update
    begin
      @meet = Meet.find(params[:id])
      user = User.find_by_jti(decrypt_payload[0]["jti"])

      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      unless @meet.user == user
        return render json: { error: "Unauthorized" }, status: :unauthorized
      end

      if @meet.update(meet_params)
        render json: @meet
      else
        render json: { errors: @meet.errors.full_messages }, status: :unprocessable_entity
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
    end
  end

  private

    def meet_params
      params.require(:meet).permit(:body, :hosted_at, :user_id, tag_list: [])
    end

    def encrypt_payload
      payload = @user.as_json(only: [ :email, :jti ])
      token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, "HS256")
      token
    end

    def decrypt_payload
      jwt = request.headers["Authorization"]
      token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: "HS256" })
      token
    end
end
