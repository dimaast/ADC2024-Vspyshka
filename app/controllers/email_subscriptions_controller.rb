class EmailSubscriptionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_email_subscription, only: %i[ show edit update destroy ]

  def index
    @email_subscriptions = EmailSubscription.all
  end

  def show
  end

  def new
    @email_subscription = EmailSubscription.new
  end

  def edit
  end

  def create
    @email_subscription = EmailSubscription.new(email_subscription_params)

    respond_to do |format|
      if @email_subscription.save
        format.turbo_stream { render :show }

        format.json { render :show, status: :created, location: @email_subscription }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @email_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @email_subscription.update(email_subscription_params)
        format.html { redirect_to @email_subscription, notice: "Email subscription was successfully updated." }
        format.json { render :show, status: :ok, location: @email_subscription }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @email_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @email_subscription.destroy!

    respond_to do |format|
      format.html { redirect_to email_subscriptions_path, status: :see_other, notice: "Email subscription was successfully destroyed." }
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