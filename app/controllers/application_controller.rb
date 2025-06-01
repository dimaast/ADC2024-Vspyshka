class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern

  before_action :authenticate_user
  before_action :authenticate_guest

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def authenticate_user
    # cookies.delete(:user_id)
    if current_user
      unless cookies[:user_id]
        cookies.encrypted[:user_id] = current_user.id
      end
    end
  end

  def authenticate_guest
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
