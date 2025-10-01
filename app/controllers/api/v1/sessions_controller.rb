class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user, only: [ :destroy ]

  before_action :sign_in_params, only: :create
  before_action :load_user_by_email, only: :create
  before_action :load_user_by_jti, only: :destroy

  # Sign in
  def create
    Rails.logger.info "Sign in attempt for email: #{sign_in_params[:email]}"
    Rails.logger.info "User found: #{@user.present?}"
    Rails.logger.info "User email: #{@user&.email}"
    Rails.logger.info "Password provided: #{sign_in_params[:password].present?}"
    
    if @user
      # Используем только valid_password? метод от Devise
      password_valid = @user.valid_password?(sign_in_params[:password])
      
      Rails.logger.info "Password valid (valid_password?): #{password_valid}"
      Rails.logger.info "User encrypted_password: #{@user.encrypted_password.present?}"
      
      if password_valid
        Rails.logger.info "Password valid, generating JWT"
      render json: {
        messages: "Signed In Successfully",
        isSuccess: true,
        jwt: encrypt_payload,
        profileId: @user.profile&.id
      }, status: :ok
      else
        Rails.logger.info "Password invalid"
        render json: {
          messages: "Sign In Failed - Invalid password",
          isSuccess: false
        }, status: :unauthorized
      end
    else
      Rails.logger.info "User not found"
      render json: {
        messages: "Sign In Failed - User not found",
        isSuccess: false
      }, status: :unauthorized
    end
  end

  # Sign out
  def destroy
    if @user && @user.update_column(:jti, SecureRandom.uuid)
      render json: {
        messages: "Signed Out Successfully",
        isSuccess: true,
        data: {}
      }, status: :ok
    else
      render json: {
        messages: "Sign Out Failed - Unauthorized",
        isSuccess: false
      }, status: :unauthorized
    end
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password, :format)
  end

  def load_user_by_email
    begin
      email = sign_in_params[:email]
      Rails.logger.info "Looking for user with email: #{email}"
      
      # Находим пользователя напрямую
      @user = User.find_by(email: email)
      Rails.logger.info "User found: #{@user.present?}"
      Rails.logger.info "User ID: #{@user&.id}"
      Rails.logger.info "User email: #{@user&.email}"

      if @user
        @user
      else
        Rails.logger.info "User not found for email: #{email}"
        render json: {
          messages: "Sign In Failed - User not found",
          is_success: false,
          data: {}
        }, status: :unauthorized
      end
    rescue => e
      Rails.logger.error "Error in load_user_by_email: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: {
        messages: "Sign In Failed - Authentication error: #{e.message}",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end

  def load_user_by_jti
    begin
      @user = User.find_by_jti(decrypt_payload[0]["jti"])

      if @user
        @user
      else
        render json: {
          messages: "Sign Out Failed - Unauthorized",
          is_success: false
        }, status: :unauthorized
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: {
        messages: "Sign Out Failed - Invalid token",
        is_success: false
      }, status: :unauthorized
    rescue => e
      render json: {
        messages: "Sign Out Failed - Authentication error",
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
