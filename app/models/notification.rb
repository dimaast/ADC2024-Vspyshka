class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :comment, optional: true
  belongs_to :notificationable, polymorphic: true, optional: true

end