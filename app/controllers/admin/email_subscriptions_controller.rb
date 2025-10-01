class Admin::EmailSubscriptionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_email_subscription, only: %i[ show destroy ]

  def index
    @email_subscriptions = EmailSubscription.all
  end

  def show
  end

  def destroy
    @email_subscription.destroy!

    respond_to do |format|
      format.html { redirect_to admin_email_subscriptions_path, status: :see_other, notice: "Email subscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_email_subscription
      @email_subscription = EmailSubscription.find(params[:id])
    end

    def email_subscription_params
      params.require(:email_subscription).permit(:email)
    end
end