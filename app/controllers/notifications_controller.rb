# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  # POST /notifications/mark_all_read
  def mark_all_read
    # Обновляем все непрочитанные для текущего пользователя
    current_user.notifications.where(read: false).update_all(read: true)
    head :ok
  end
end
