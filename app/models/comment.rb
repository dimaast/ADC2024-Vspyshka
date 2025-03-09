class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :favourites, as: :favouriteable

  validates :user_id, presence: true

  has_many :replies, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
  belongs_to :comment, optional: true

  default_scope { order(created_at: "ASC") }
  scope :no_replies, -> { where(comment_id: nil) }

  after_update_commit { current_user ? broadcast_append_to("comments") : nil }
  # after_create_commit { broadcast_prepend_to [ commentable, :comments ] }
end
