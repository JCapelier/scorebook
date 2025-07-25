class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :session_players, dependent: :destroy
  has_one :user_stat, dependent: :destroy

  has_one_attached :profile_pic
end
