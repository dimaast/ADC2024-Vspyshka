class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :username, presence: { message: "Необходимо указать имя пользователя" }
  validates :email, presence: { message: "Необходимо указать почту" }

  has_many :events
  has_many :meets
  has_many :communities
  has_many :comments
  has_many :notifications
  has_many :favourites, dependent: :destroy
  has_many :favourite_meets, through: :favourites, source: :favouriteable, source_type: 'Meet'
  has_many :favourite_events, through: :favourites, source: :favouriteable, source_type: 'Event'
  has_many :responses
  has_many :subscriptions
  has_many :notifications, dependent: :destroy

  has_one :profile, dependent: :destroy
  after_create :create_profile

  def create_profile
    Profile.create!(user: self, 
                   first_name: "Имя",
                   last_name: "Фамилия",
                   middle_name: "Отчество",
                   name: "Фамилия Имя")
  end

  def full_name
    profile&.full_name || username
  end

def unread_notifications
  notifications.where(read: false)
end


  acts_as_taggable_on :tags
end
