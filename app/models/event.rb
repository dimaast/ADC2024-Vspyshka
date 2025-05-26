class Event < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:title, :body]

  validates :title, presence: true, length: { minimum: 5 }
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :community, optional: true
  has_many :favourites, as: :favouriteable
  has_many :responses, as: :responseable
  mount_uploader :cover, CoverUploader

  acts_as_taggable_on :tags
  acts_as_taggable_on :categories
end

# def as_json
#   { title: title,
#     body: body,
#     user: user.username }
# end
