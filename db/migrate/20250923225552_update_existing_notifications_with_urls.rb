class UpdateExistingNotificationsWithUrls < ActiveRecord::Migration[7.2]
  def up
    # Обновляем уведомления о комментариях
    Notification.where.not(comment_id: nil).find_each do |notification|
      comment = Comment.find_by(id: notification.comment_id)
      if comment
        parent = comment.commentable
        url = Rails.application.routes.url_helpers.polymorphic_url(parent, anchor: "comment_#{comment.id}")
        notification.update_columns(url: url, notificationable_type: parent.class.name, notificationable_id: parent.id)
      end
    end
    
    # Обновляем уведомления о напоминаниях (содержат "Скоро начнётся" или "Напоминание")
    Notification.where(comment_id: nil)
                .where("body LIKE ? OR body LIKE ?", "%Скоро начнётся%", "%Напоминание%")
                .find_each do |notification|
      # Пытаемся найти связанное событие или встречу по тексту уведомления
      title_match = notification.body.match(/'([^']+)'/)
      if title_match
        title = title_match[1]
        
        # Ищем событие или встречу по заголовку
        event = Event.find_by("title ILIKE ?", "%#{title}%")
        meet = Meet.find_by("body ILIKE ?", "%#{title}%")
        
        if event
          url = Rails.application.routes.url_helpers.event_path(event)
          notification.update_columns(url: url, notificationable_type: 'Event', notificationable_id: event.id)
        elsif meet
          url = Rails.application.routes.url_helpers.meet_path(meet)
          notification.update_columns(url: url, notificationable_type: 'Meet', notificationable_id: meet.id)
        end
      end
    end
  end

  def down
    # Откатываем изменения
    Notification.update_all(url: nil, notificationable_type: nil, notificationable_id: nil)
  end
end
