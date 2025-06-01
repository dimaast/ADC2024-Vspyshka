# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :comment, optional: true

  # Поле “read” (boolean), по умолчанию false. 
  # В миграции это могло выглядеть так:
  #   t.boolean :read, default: false, null: false
  #   t.references :user, foreign_key: true
  #   t.references :comment, foreign_key: true, null: true
end
