# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :email_address, use: :slugged
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :group_memberships
  has_many :groups, through: :group_memberships

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, email: true, uniqueness: true

  has_many :friendships
  has_many :friends, -> { where(friendships: { status: "accepted" }) },
           through: :friendships

  has_many :conversation_participants
  has_many :conversations, through: :conversation_participants
  has_many :messages, foreign_key: "sender_id", dependent: :destroy

  def unread_messages
    Message.joins(:conversation)
      .where.not(sender_id: id)
      .where(conversation_id: conversation_participants.select(:conversation_id))
      .where("messages.created_at > COALESCE((SELECT last_read_at FROM conversation_participants
              WHERE user_id = ? AND conversation_id = messages.conversation_id), TIMESTAMP '1970-01-01')", id)
  end

  def unread_messages_count
    ConversationParticipant.where(user_id: id)
      .joins(conversation: :messages)
      .where("messages.sender_id != ?", id)
      .where("messages.created_at > COALESCE(conversation_participants.last_read_at, TIMESTAMP '1970-01-01')")
      .count
  end

  def to_s
    email_address
  end
end
