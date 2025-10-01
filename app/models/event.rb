class Event < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [ :title, :body ], using: { trigram: { threshold: 0.2 } }

  validates :title, presence: true, length: { minimum: 5 }
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :community, optional: true
  has_many :favourites, as: :favouriteable, dependent: :destroy
  has_many :favourited_by, through: :favourites, source: :user
  has_many :responses, as: :responseable
  has_many :reports, dependent: :destroy
  mount_uploader :cover, CoverUploader

  acts_as_taggable_on :tags
  acts_as_taggable_on :categories
end