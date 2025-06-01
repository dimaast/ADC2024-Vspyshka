class Profile < ApplicationRecord
  belongs_to :user

  belongs_to :faculty, optional: true
  belongs_to :program, optional: true

  has_many :subscriptions, as: :subscriptionable

  mount_uploader :avatar, ProfileAvatarUploader
end
