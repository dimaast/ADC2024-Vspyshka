class AddUrlAndNotificationableToNotifications < ActiveRecord::Migration[7.2]
  def change
    add_column :notifications, :url, :string
    add_reference :notifications, :notificationable, null: true, polymorphic: true
  end
end
