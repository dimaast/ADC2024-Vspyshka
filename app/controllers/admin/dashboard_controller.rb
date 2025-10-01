class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @communities_count = Community.count
    @users_count = User.count
    @reports_count = Report.count
    @reports_pending = Report.where(status: 'pending').count
    @reports_approved = Report.where(status: 'approved').count
    @reports_rejected = Report.where(status: 'rejected').count
  end

  private

  def require_admin!
    unless current_user&.role == "admin"
      redirect_to root_path, alert: "Доступ только для администраторов."
    end
  end
end