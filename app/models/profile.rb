class Profile < ApplicationRecord
  belongs_to :user
  has_many :subscriptions, as: :subscriptionable

  mount_uploader :avatar, ProfileAvatarUploader
end
