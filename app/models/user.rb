class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :meets
  has_many :communities
  has_many :comments
  has_many :favourites
  has_many :responses
  has_many :subscriptions

  has_one :profile
  after_create :create_profile

  def create_profile
    Profile.create!(user: self, name: username)
  end
end
