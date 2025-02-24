class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_and_belongs_to_many :groups
  def to_s
    email_address
  end
end
