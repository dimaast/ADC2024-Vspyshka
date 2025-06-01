class Faculty < ApplicationRecord
  validates :name, presence: true
  has_many :profiles, dependent: :nullify

  has_many :programs
end
