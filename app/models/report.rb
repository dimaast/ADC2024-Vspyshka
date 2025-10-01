class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates :reason, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :reportable_id, uniqueness: { scope: [:user_id, :reportable_type], message: "Вы уже жаловались на этот объект" }

  enum status: { pending: 0, approved: 1, rejected: 2 }

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :rejected, -> { where(status: :rejected) }
end