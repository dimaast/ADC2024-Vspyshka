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
      current_user.subscriptions.create!(subscriptionable_type: params[:type], subscriptionable_id: params[:id])
    end
  end
end
