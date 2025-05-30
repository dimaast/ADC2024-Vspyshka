class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [ :create, :destroy ]
  skip_before_action :verify_signed_out_user, only: [ :destroy ]

  before_action :sign_in_params, only: :create
  before_action :load_user_by_email, only: :create
  before_action :load_user_by_jti, only: :destroy

  # Sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      render json: {
        messages: "Signed In Successfully",
        is_success: true,
        jwt: encrypt_payload,
        profile_id: @user.profile&.id
      }, status: :ok
    else
       render json: {
        messages: "Sign In Failed - Unauthorized",
        is_success: false
      }, status: :unauthorized
    end
  end

  # Sign out
  def destroy
    if @user && @user.update_column(:jti, SecureRandom.uuid)
      render json: {
        messages: "Signed Out Successfully",
        is_success: true,
        data: {}
      }, status: :ok
    else
      render json: {
        messages: "Sign Out Failed - Unauthorized",
        is_success: false
      }, status: :unauthorized
    end
  end

  private

  def sign_in_params
    params.permit(:email, :password, :format)
  end

  def load_user_by_email
    @user = User.find_for_database_authentication(email: sign_in_params[:email])

    if @user
      @user
    else
      render json: {
        messages: "Sign In Failed - Unauthorized",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end

  def load_user_by_jti
      puts decrypt_payload
      @user = User.find_by_jti(decrypt_payload[0]["jti"])

    if @user
      @user
    else
      render json: {
        messages: "Sign Out Failed - Unauthorized",
        is_success: false
      }, status: :unauthorized
    end
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
