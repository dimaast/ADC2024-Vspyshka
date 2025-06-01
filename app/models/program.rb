class Program < ApplicationRecord
  belongs_to :faculty

  validates :name, presence: true
  has_many :profiles, dependent: :nullify
end
