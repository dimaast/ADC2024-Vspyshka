class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reportable, only: [ :new, :create ]

  def new
    @report = Report.new
    @reportable = @reportable # для передачи в форму
  end

  def create
    @report = @reportable.reports.build(report_params)
    @report.user = current_user

    if @report.save
      redirect_to @reportable, notice: "Жалоба успешно отправлена. Мы рассмотрим её в ближайшее время."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_reportable
    klass = params[:reportable_type].classify.constantize
    @reportable = klass.find(params[:reportable_id])
  end

  def report_params
    params.require(:report).permit(:reason)
  end
end