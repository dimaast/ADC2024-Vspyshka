class ReminderNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.zone.now

    events_soon = Event.where(hosted_at: (now + 24.hours).beginning_of_minute..(now + 24.hours + 1.minute))
    meets_soon  = Meet.where(hosted_at: (now + 24.hours).beginning_of_minute..(now + 24.hours + 1.minute))

    events_very_soon = Event.where(hosted_at: (now + 1.hour).beginning_of_minute..(now + 1.hour + 1.minute))
    meets_very_soon  = Meet.where(hosted_at: (now + 1.hour).beginning_of_minute..(now + 1.hour + 1.minute))

    send_reminders(events_soon, :day)
    send_reminders(meets_soon, :day)
    send_reminders(events_very_soon, :hour)
    send_reminders(meets_very_soon, :hour)
  end

  private

  def send_reminders(records, type)
    records.each do |record|

      responses = Response.where(responseable: record)
      responses.each do |response|
        user = response.user

        registered_at = response.created_at
        time_to_event = record.hosted_at - registered_at

        if type == :hour && time_to_event < 48.hours && time_to_event > 1.hour
          create_notification(user, record, :hour)
        elsif type == :day && time_to_event >= 48.hours && time_to_event > 24.hours
          create_notification(user, record, :day)
        end
      end
    end
  end

  def create_notification(user, record, type)
    return if Notification.exists?(user: user, comment: nil, body: notification_body(record, type), created_at: (Time.zone.now - 2.hours)..Time.zone.now)

    url = if record.is_a?(Event)
            Rails.application.routes.url_helpers.event_path(record)
          elsif record.is_a?(Meet)
            Rails.application.routes.url_helpers.meet_path(record)
          end
    
    notification = Notification.create!(
      user: user,
      comment: nil,
      body: notification_body(record, type),
      read: false,
      url: url,
      notificationable: record
    )

    ActionCable.server.broadcast(
      "notifications_#{user.id}",
      {
        body: notification_body(record, type),
        url: url
      }
    )
  end

  def notification_body(record, type)
    title = record.try(:title) || record.try(:body)
    time_str = record.hosted_at.strftime("%d.%m.%Y %H:%M")
    if type == :hour
      "Скоро начнётся: '#{title}' — через 1 час (#{time_str})"
    else
      "Напоминание: завтра состоится '#{title}' (#{time_str})"
    end
  end
end