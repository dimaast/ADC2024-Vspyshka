class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscriptionable, polymorphic: true
end