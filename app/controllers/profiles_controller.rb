class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]

  def index
    @profiles = Profile.all
  end

  def show
    @profile = Profile.find(params[:id])
    today = Date.current
    @events_actual = @profile.user.events.select { |e| e.hosted_at && e.hosted_at.to_date >= today }
    @events_archive = @profile.user.events.select { |e| e.hosted_at && e.hosted_at.to_date < today }
    @meets_actual = @profile.user.meets.select { |m| m.hosted_at && m.hosted_at.to_date >= today }
    @meets_archive = @profile.user.meets.select { |m| m.hosted_at && m.hosted_at.to_date < today }

    @favourite_events = @profile.user.favourites.where(favouriteable_type: "Event").map(&:favouriteable)
    @favourite_meets = @profile.user.favourites.where(favouriteable_type: "Meet").map(&:favouriteable)
    @favourite_events_actual = @favourite_events.select { |e| e.hosted_at && e.hosted_at.to_date >= today }
    @favourite_events_archive = @favourite_events.select { |e| e.hosted_at && e.hosted_at.to_date < today }
    @favourite_meets_actual = @favourite_meets.select { |m| m.hosted_at && m.hosted_at.to_date >= today }
    @favourite_meets_archive = @favourite_meets.select { |m| m.hosted_at && m.hosted_at.to_date < today }

    @subscribers = User.joins(:subscriptions).where(subscriptions: { subscriptionable_type: 'Profile', subscriptionable_id: @profile.id })
    @community_subscriptions = Community.joins(:subscriptions).where(subscriptions: { user_id: @profile.user.id, subscriptionable_type: 'Community' })
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.tag_list = params[:profile][:tag_list] if params[:profile][:tag_list]

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)

        @profile.tag_list = params[:profile][:tag_list] if params[:profile][:tag_list]
        @profile.save

        @profile.user.update_columns(
          first_name: @profile.first_name,
          last_name: @profile.last_name,
          middle_name: @profile.middle_name
        )
        if params[:profile][:username].present?
          @profile.user.update(username: params[:profile][:username])
        end

        if params[:user].present?
          @profile.user.update(user_params)
        end
        format.html { redirect_to @profile, notice: "Профиль был успешно обновлен." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def subscribers
    @profile = Profile.find(params[:id])
    @subscribers = User.joins(:subscriptions).where(subscriptions: { subscriptionable_type: 'Profile', subscriptionable_id: @profile.id })
    @subscriptions = Profile.where(id: Subscription.where(user_id: @profile.user.id, subscriptionable_type: 'Profile').select(:subscriptionable_id))
    @communities = Community.joins(:subscriptions).where(subscriptions: { user_id: @profile.user.id, subscriptionable_type: 'Community' })
  end

  def subscriptions
    @profile = Profile.find(params[:id])
    @communities = Community.joins(:subscriptions).where(subscriptions: { user_id: @profile.user.id, subscriptionable_type: 'Community' }).order('subscriptions.created_at DESC')
  end

  private

    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:name, :body, :contact, :avatar, :user_id, :first_name, :last_name, :middle_name, :faculty_id, :program_id)

    end

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
    end
end