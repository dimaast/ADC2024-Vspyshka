class Api::V1::MeetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @meets = Meet.all
  end

  def show
    @meet = Meet.find(params[:id])
  end

  def create
    # puts decrypt_payload

    user = User.find_by_jti(decrypt_payload[0][":jti"])
    meet = user.meets.new(meet_params)

    if meet.save
      render json: meet, status: :created
    else
      render json: meet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @meet = Meet.find(params[:id])
    user = User.find_by_jti(decrypt_payload[0][":jti"])

    unless @meet.user == user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    @meet.destroy
    head :no_content
  end

  def update
    @meet = Meet.find(params[:id])
    user = User.find_by_jti(decrypt_payload[0][":jti"])

    unless @meet.user == user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    if @meet.update(meet_params)
      render json: @meet
    else
      render json: @meet.errors, status: :unprocessable_entity
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
