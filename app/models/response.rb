class Response < ApplicationRecord
  belongs_to :user
  belongs_to :responseable, polymorphic: true
end
