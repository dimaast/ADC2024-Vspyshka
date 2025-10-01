class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern

  before_action :set_locale
  before_action :authenticate_user
  before_action :authenticate_guest

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html do
        message = 'У вас нет прав для доступа к этой странице.'
        unless user_signed_in?
          message += ' <a href="' + view_context.new_user_registration_path + '">Зарегистрируйтесь</a>, чтобы получить доступ.'
        end
        redirect_to root_path, alert: message.html_safe
      end
    end
  end

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.json { render json: { error: 'Not Found' }, status: 404 }
      format.all { render plain: '404 Not Found', status: 404 }
    end
  end

  def authenticate_user

    if current_user
      unless cookies.encrypted[:user_id]
        cookies.encrypted[:user_id] = current_user.id
      end
    end
  end

  def authenticate_guest
    if current_user
      if cookies[:guest_token]
      else
        cookies[:guest_token] = current_user.jti
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :password, :username, :first_name, :last_name, :middle_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :first_name, :last_name, :middle_name ])
  end

  def after_update_path_for(resource)

    if resource.profile.present?
      resource.profile.update_columns(
        first_name: resource.first_name,
        last_name: resource.last_name,
        middle_name: resource.middle_name
      )
    end
    super
  end

  def after_sign_up_path_for(resource)
    puts "[DEBUG] after_sign_up_path_for вызван для пользователя: \\#{resource.id} (\\#{resource.email})"
    choose_interests_path
  end

  def after_sign_in_path_for(resource)
    if resource.role == 'admin'
      root_path
    else
      super
    end
  end

  private

  def set_locale
    I18n.locale = :ru
  end

  def not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.json { render json: { error: 'Not Found' }, status: 404 }
      format.all { render plain: '404 Not Found', status: 404 }
    end
  end

end