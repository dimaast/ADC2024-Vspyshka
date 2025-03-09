class EmailSubscriptionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_email_subscription, only: %i[ show edit update destroy ]

  # GET /email_subscriptions or /email_subscriptions.json
  def index
    @email_subscriptions = EmailSubscription.all
  end

  # GET /email_subscriptions/1 or /email_subscriptions/1.json
  def show
  end


  # GET /email_subscriptions/new
  def new
    @email_subscription = EmailSubscription.new
  end

  # GET /email_subscriptions/1/edit
  def edit
  end

  # POST /email_subscriptions or /email_subscriptions.json
  def create
    @email_subscription = EmailSubscription.new(email_subscription_params)

    respond_to do |format|
      if @email_subscription.save
        format.turbo_stream { render :show }
        # format.html { redirect_to @email_subscription, notice: "Email subscription was successfully created." }
        format.json { render :show, status: :created, location: @email_subscription }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @email_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_subscriptions/1 or /email_subscriptions/1.json
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

  # DELETE /email_subscriptions/1 or /email_subscriptions/1.json
  def destroy
    @email_subscription.destroy!

    respond_to do |format|
      format.html { redirect_to email_subscriptions_path, status: :see_other, notice: "Email subscription was successfully destroyed." }
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
