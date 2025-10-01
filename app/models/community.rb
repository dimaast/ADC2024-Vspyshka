class Community < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [ :title, :body ], using: { trigram: { threshold: 0.2 } }

  belongs_to :user, optional: true
  has_many :events

  has_many :subscriptions, as: :subscriptionable

  acts_as_taggable_on :tags

  mount_uploader :cover, CommunityCoverUploader
end