class Profile < ApplicationRecord
  belongs_to :user

  belongs_to :faculty, optional: true
  belongs_to :program, optional: true

  has_many :subscriptions, as: :subscriptionable

  mount_uploader :avatar, ProfileAvatarUploader

  validates :first_name, presence: { message: "Необходимо указать имя" }
  validates :last_name, presence: { message: "Необходимо указать фамилию" }

  def full_name
    [ last_name, first_name ].compact.join(" ")
  end
end