class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :favouriteable, polymorphic: true
end
