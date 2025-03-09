class Community < ApplicationRecord
  belongs_to :user, optional: true
  has_many :events

  has_many :subscriptions, as: :subscriptionable

  mount_uploader :cover, CommunityCoverUploader
end
