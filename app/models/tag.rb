class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # Методы для получения тегов и категорий
  scope :tags_list, -> { where(tag_type: "tag") }
  scope :categories_list, -> { where(tag_type: "category") }
end
