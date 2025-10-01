class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_all_read

    current_user.notifications.where(read: false).update_all(read: true)
    head :ok
  end

  def mark_read
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    head :ok
  end

  def redirect
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true) if notification.url.present?
    
    if notification.url.present?
      redirect_to notification.url
    else
      redirect_to root_path, alert: 'Ссылка недоступна'
    end
  end
end