class Admin::EmailSubscriptionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_email_subscription, only: %i[ show destroy ]

  # GET /email_subscriptions or /email_subscriptions.json
  def index
    @email_subscriptions = EmailSubscription.all
  end

  # GET /email_subscriptions/1 or /email_subscriptions/1.json
  def show
  end

  # DELETE /email_subscriptions/1 or /email_subscriptions/1.json
  def destroy
    @email_subscription.destroy!

    respond_to do |format|
      format.html { redirect_to admin_email_subscriptions_path, status: :see_other, notice: "Email subscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_subscription
      @email_subscription = EmailSubscription.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_subscription_params
      params.require(:email_subscription).permit(:email)
    end
end
