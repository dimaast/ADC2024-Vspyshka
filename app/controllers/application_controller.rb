class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def authenticate_user
    if current_user
      if cookies[:guest_token]
        puts cookies[:guest_token] == current_user.jti
      else
        cookies[:guest_token] = current_user.jti
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :password, :username ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end
end
