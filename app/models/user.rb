class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates_uniqueness_of :auth_token
  before_create :generate_auth_token!

  has_many :task, dependent: :destroy

  def info
    "#{self.email} - #{self.created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_auth_token!
    loop do
      self.auth_token = Devise.friendly_token
      break if !User.exists?(auth_token: self.auth_token)
    end
  end
  
  # attr_accessor :name
  # validates_presence_of :name
end