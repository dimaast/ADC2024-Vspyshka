class Api::V1::FavouritesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_jwt

  # GET /api/v1/favourites
  def index
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 100].min
    
    type = params[:type] # 'Event', 'Meet', 'Community' или nil для всех
    
    favourites_query = @current_user.favourites.includes(:favouriteable)
    favourites_query = favourites_query.where(favouriteable_type: type) if type.present?
    
    @favourites = favourites_query.order(created_at: :desc)
                                 .limit(per_page)
                                 .offset((page - 1) * per_page)
    
    total_count = favourites_query.count
    total_pages = (total_count.to_f / per_page).ceil
    
    render json: {
      favourites: @favourites.map { |fav| 
        favouriteable = fav.favouriteable
        base_data = {
          id: fav.id,
          favouriteable_type: fav.favouriteable_type,
          favouriteable_id: fav.favouriteable_id,
          created_at: fav.created_at
        }
        
        case fav.favouriteable_type
        when 'Event'
          base_data.merge({
            title: favouriteable.title,
            body: favouriteable.body,
            hosted_at: favouriteable.hosted_at,
            placed_at: favouriteable.placed_at,
            cover: favouriteable.cover.url,
            tags: favouriteable.tag_list,
            categories: favouriteable.category_list,
            user: {
              id: favouriteable.user&.id,
              username: favouriteable.user&.username,
              first_name: favouriteable.user&.first_name,
              last_name: favouriteable.user&.last_name
            }
          })
        when 'Meet'
          base_data.merge({
            body: favouriteable.body,
            hosted_at: favouriteable.hosted_at,
            placed_at: favouriteable.placed_at,
            tags: favouriteable.tag_list,
            user: {
              id: favouriteable.user&.id,
              username: favouriteable.user&.username,
              first_name: favouriteable.user&.first_name,
              last_name: favouriteable.user&.last_name
            }
          })
        when 'Community'
          base_data.merge({
            title: favouriteable.title,
            body: favouriteable.body,
            cover: favouriteable.cover.url,
            contact: favouriteable.contact,
            tags: favouriteable.tag_list,
            subscribers_count: favouriteable.subscriptions.count,
            events_count: favouriteable.events.count,
            user: {
              id: favouriteable.user&.id,
              username: favouriteable.user&.username,
              first_name: favouriteable.user&.first_name,
              last_name: favouriteable.user&.last_name
            }
          })
        else
          base_data
        end
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

  # POST /api/v1/favourites
  def create
    begin
      favouriteable_type = params[:favouriteable_type]
      favouriteable_id = params[:favouriteable_id]
      
      unless favouriteable_type.present? && favouriteable_id.present?
        return render json: { error: "favouriteable_type and favouriteable_id are required" }, status: :bad_request
      end
      
      # Проверяем, что тип поддерживается
      unless ['Event', 'Meet', 'Community'].include?(favouriteable_type)
        return render json: { error: "Unsupported favouriteable_type. Supported types: Event, Meet, Community" }, status: :bad_request
      end
      
      # Находим объект для добавления в избранное
      favouriteable = Object.const_get(favouriteable_type).find(favouriteable_id)
      
      # Проверяем, не добавлен ли уже в избранное
      if @current_user.favourites.where(favouriteable: favouriteable).exists?
        return render json: { error: "Already in favourites" }, status: :unprocessable_entity
      end
      
      # Создаем запись в избранном
      favourite = @current_user.favourites.create!(favouriteable: favouriteable)
      
      render json: {
        success: true,
        message: "Added to favourites",
        favourite: {
          id: favourite.id,
          favouriteable_type: favourite.favouriteable_type,
          favouriteable_id: favourite.favouriteable_id,
          created_at: favourite.created_at
        }
      }, status: :created
      
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Object not found" }, status: :not_found
    rescue NameError
      render json: { error: "Invalid favouriteable_type" }, status: :bad_request
    rescue => e
      render json: { error: "Failed to add to favourites: #{e.message}" }, status: :internal_server_error
    end
  end

  # DELETE /api/v1/favourites/:id
  def destroy
    begin
      favourite = @current_user.favourites.find(params[:id])
      favourite.destroy
      
      render json: {
        success: true,
        message: "Removed from favourites"
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Favourite not found" }, status: :not_found
    rescue => e
      render json: { error: "Failed to remove from favourites: #{e.message}" }, status: :internal_server_error
    end
  end

  # POST /api/v1/favourites/toggle
  def toggle
    begin
      favouriteable_type = params[:favouriteable_type]
      favouriteable_id = params[:favouriteable_id]
      
      unless favouriteable_type.present? && favouriteable_id.present?
        return render json: { error: "favouriteable_type and favouriteable_id are required" }, status: :bad_request
      end
      
      # Проверяем, что тип поддерживается
      unless ['Event', 'Meet', 'Community'].include?(favouriteable_type)
        return render json: { error: "Unsupported favouriteable_type. Supported types: Event, Meet, Community" }, status: :bad_request
      end
      
      # Находим объект
      favouriteable = Object.const_get(favouriteable_type).find(favouriteable_id)
      
      # Ищем существующую запись в избранном
      existing_favourite = @current_user.favourites.find_by(favouriteable: favouriteable)
      
      if existing_favourite
        # Удаляем из избранного
        existing_favourite.destroy
        action = "removed"
        message = "Removed from favourites"
      else
        # Добавляем в избранное
        favourite = @current_user.favourites.create!(favouriteable: favouriteable)
        action = "added"
        message = "Added to favourites"
      end
      
      render json: {
        success: true,
        action: action,
        message: message,
        is_favourite: action == "added"
      }
      
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Object not found" }, status: :not_found
    rescue NameError
      render json: { error: "Invalid favouriteable_type" }, status: :bad_request
    rescue => e
      render json: { error: "Failed to toggle favourite: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def authenticate_user_jwt
    begin
      Rails.logger.info "FavouritesController: Starting JWT authentication"
      Rails.logger.info "Authorization header: #{request.headers['Authorization']}"
      
      @current_user = User.find_by_jti(decrypt_payload[0]["jti"])
      Rails.logger.info "User found: #{@current_user.present?}"
      Rails.logger.info "User ID: #{@current_user&.id}"
      
      unless @current_user
        Rails.logger.info "User not found for JTI"
        render json: { error: "User not found" }, status: :unauthorized
        return false
      end
      
      Rails.logger.info "Authentication successful"
      true
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error "JWT decode error: #{e.message}"
      render json: { error: "Invalid or expired token" }, status: :unauthorized
      false
    rescue => e
      Rails.logger.error "Authentication failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
      false
    end
  end

  def decrypt_payload
    jwt = request.headers["Authorization"]
    Rails.logger.info "JWT token: #{jwt}"
    raise "No authorization header" if jwt.blank?
    
    # Убираем "Bearer " префикс если есть
    jwt = jwt.gsub(/^Bearer\s+/, '') if jwt.start_with?('Bearer')
    Rails.logger.info "JWT token after cleanup: #{jwt}"
    
    token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: "HS256" })
    Rails.logger.info "Decoded payload: #{token[0]}"
    token
  end
end
