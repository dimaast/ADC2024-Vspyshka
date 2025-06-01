class AddReadToNotifications < ActiveRecord::Migration[7.2]
  def change
    add_column :notifications, :read, :boolean
  end
end
