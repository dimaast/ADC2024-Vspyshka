class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  scope :tags_list, -> { where(tag_type: "tag") }
  scope :categories_list, -> { where(tag_type: "category") }

  def self.tags_list_for_events
    where(tag_type: "tag")
  end
  
  def self.categories_list_for_events
    where(tag_type: "category")
  end
end