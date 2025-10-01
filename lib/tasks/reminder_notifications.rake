namespace :reminder_notifications do
  desc "Отправить напоминания о событиях и встречах"
  task send: :environment do
    ReminderNotificationsJob.perform_now
  end
end 