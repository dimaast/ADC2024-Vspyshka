class Community < ApplicationRecord
  belongs_to :user
  has_many :events
  mount_uploader :cover, CommunityCoverUploader
end
