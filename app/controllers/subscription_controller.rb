class SubscriptionController < ApplicationController
  before_action :authenticate_user!

  def toggle
    subscriptionable = Object.const_get(params[:type]).find(params[:id])
    subscriptions = subscriptionable.subscriptions.where(user_id: current_user.id)

    if subscriptions && subscriptions.count > 0
      subscriptions.each do |subscription|
        subscription.destroy!
      end
    else
      subscription = current_user.subscriptions.create!(subscriptionable_type: params[:type], subscriptionable_id: params[:id])

      if params[:type] == 'Profile'
        profile = Profile.find(params[:id])
        subscribed_user = profile.user

        unless subscribed_user == current_user
          body = "Пользователь #{current_user.username} подписался на ваш профиль"
          url = Rails.application.routes.url_helpers.profile_path(profile)
          
          notification = subscribed_user.notifications.create!(
            body: body,
            comment: nil,
            read: false,
            url: url,
            notificationable: profile
          )
          
          ActionCable.server.broadcast(
            "notifications_#{subscribed_user.id}",
            {
              body: body,
              url: url
            }
          )
        end
      end
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("subscription_button_#{params[:type]}_#{params[:id]}", partial: "subscription/button", locals: { subscriptionable: subscriptionable }) }
      format.html { redirect_back fallback_location: root_path }
    end
  end
end