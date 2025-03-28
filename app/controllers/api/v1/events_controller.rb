class Api::V1::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    puts "decrypt_payload"
    puts decrypt_payload

    user = User.find_by_jti(decrypt_payload[0][":jti"])
    event = user.events.new(event_params)

    if event.save
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    user = User.find_by_jti(decrypt_payload[0][":jti"])

    unless @event.user == user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    @event.destroy
    head :no_content
  end

  def update
    @event = Event.find(params[:id])
    user = User.find_by_jti(decrypt_payload[0][":jti"])

    unless @event.user == user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

    def event_params
      params.require(:event).permit(:title, :body, :hosted_at, :cover, :user_id, :community_id, :placed_at, :placed_additional, tag_list: [], category_list: [])
    end

    def encrypt_payload
      payload = @user.as_json(only: [ :email, :jti ])
      token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, "HS256")
    end

    def decrypt_payload
      jwt = request.headers["Authorization"]
      token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: "HS256" })
    end
end
