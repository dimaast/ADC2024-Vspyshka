class Admin::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_report, only: [:show, :update]

  def index
    @reports = Report.includes(:event, :user).order(created_at: :desc)
  end

  def show
  end

  def update
    if @report.update(report_params)
      redirect_to admin_reports_path, notice: 'Статус жалобы успешно обновлен'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:status)
  end

  def ensure_admin
    unless current_user.role == "admin"
      redirect_to root_path, alert: "У вас нет доступа к этой странице"
    end
  end
end
