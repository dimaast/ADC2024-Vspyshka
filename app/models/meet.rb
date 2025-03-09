class Meet < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :favourites, as: :favouriteable
  has_many :responses, as: :responseable

  validates :body, presence: true, length: { minimum: 50 }
end
