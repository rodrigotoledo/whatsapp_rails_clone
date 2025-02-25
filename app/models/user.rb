class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_and_belongs_to_many :groups
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy

  def to_s
    email_address
  end

  def chat_with(receiver)
    case receiver
    when User
      Message.where(
        "(sender_id = :user_id AND receiver_id = :receiver_id) OR
        (sender_id = :receiver_id AND receiver_id = :user_id)",
        user_id: id, receiver_id: receiver.id
      ).order(:created_at)

    when Group
      receiver.messages.order(:created_at)
    end
  end
end
