class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  protected

  def authenticate_user_jwt
    begin
      @current_user = User.find_by_jti(decrypt_payload[0]["jti"])
      
      unless @current_user
        render json: { error: "User not found" }, status: :unauthorized
        return false
      end
      
      true
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { error: "Invalid or expired token" }, status: :unauthorized
      false
    rescue => e
      render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
      false
    end
  end

  def current_user
    @current_user
  end

  def decrypt_payload
    jwt = request.headers["Authorization"]
    raise "No authorization header" if jwt.blank?
    
    token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: "HS256" })
    token
  end

  def render_error(message, status = :bad_request)
    render json: { error: message }, status: status
  end

  def render_success(data = {}, message = "Success")
    render json: { success: true, message: message, data: data }
  end
end
