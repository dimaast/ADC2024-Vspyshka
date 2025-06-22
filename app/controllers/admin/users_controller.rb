class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @users = User.includes(:profile).all.order(:id)
  end

  private

  def require_admin!
    unless current_user&.role == 'admin'
      redirect_to root_path, alert: 'Доступ только для администраторов.'
    end
  end
end 