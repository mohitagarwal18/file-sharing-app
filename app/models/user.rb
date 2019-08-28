class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: {maximum: 50}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP }
  before_save { self.email = email.downcase }
  has_many :artifacts, dependent: :destroy
  
end
