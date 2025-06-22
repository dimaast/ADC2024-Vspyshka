class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:new, :create]

  def new
    @report = Report.new
  end

  def create
    @report = @event.reports.build(report_params)
    @report.user = current_user

    if @report.save
      redirect_to @event, notice: 'Жалоба успешно отправлена. Мы рассмотрим её в ближайшее время.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def report_params
    params.require(:report).permit(:reason)
  end
end
