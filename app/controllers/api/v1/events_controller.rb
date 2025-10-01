class Api::V1::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /events or /events.json
  def index
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 100].min # Ограничиваем максимум 100 записей на страницу
    
    @events = Event.order(created_at: :desc)
                   .limit(per_page)
                   .offset((page - 1) * per_page)
    
    total_count = Event.count
    total_pages = (total_count.to_f / per_page).ceil
    
    render json: {
      events: @events.map { |event| event.as_json.merge(
        tags: event.tag_list,
        categories: event.category_list
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
    @event = Event.find(params[:id])
  end

  def create
    begin
      user = User.find_by_jti(decrypt_payload[0]["jti"])
      
      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      event = user.events.new(event_params)

      if event.save
        render json: event, status: :created
      else
        render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
    end
  end

  def destroy
    begin
      @event = Event.find(params[:id])
      user = User.find_by_jti(decrypt_payload[0]["jti"])

      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      unless @event.user == user
        return render json: { error: "Unauthorized" }, status: :unauthorized
      end

      @event.destroy
      head :no_content
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
    end
  end

  def update
    begin
      @event = Event.find(params[:id])
      user = User.find_by_jti(decrypt_payload[0]["jti"])

      unless user
        return render json: { error: "User not found" }, status: :unauthorized
      end

      unless @event.user == user
        return render json: { error: "Unauthorized" }, status: :unauthorized
      end

      if @event.update(event_params)
        render json: @event
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
    end
  end

  # GET /events/places
  def places
    places = [
      'Онлайн',
      'Корпус на Покровке',
      'Корпус на Шаболовке',
      'Корпус на Мясницкой',
      'Корпус в Строгино',
      'Культурный центр ЗИЛ',
      'Другое'
    ]
    render json: { places: places }
  end

  private

    def event_params
      params.require(:event).permit(:title, :body, :hosted_at, :cover, :user_id, :community_id, :placed_at, :placed_additional, tag_list: [], category_list: [])
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
