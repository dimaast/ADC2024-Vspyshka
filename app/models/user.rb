class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: { message: "Необходимо указать имя пользователя" }

  has_many :events
  has_many :meets
  has_many :communities
  has_many :comments
  has_many :favourites
  has_many :responses
  has_many :subscriptions

  has_one :profile, dependent: :destroy
  after_create :create_profile

  def create_profile
    Profile.create!(user: self, name: "Ваше имя")
  end

  acts_as_taggable_on :tags
end
