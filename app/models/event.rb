class Event < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5 }
  has_many :comments, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :community, optional: true
  mount_uploader :cover, CoverUploader
end
