# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  
  # Relacionamentos com Conversation
  has_many :conversations_as_user1, class_name: "Conversation", foreign_key: "user1_id", dependent: :destroy
  has_many :conversations_as_user2, class_name: "Conversation", foreign_key: "user2_id", dependent: :destroy

  # Normalização e validações
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, email: true, uniqueness: true

  # Relacionamentos de amizade
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # Relacionamento com grupos
  has_and_belongs_to_many :groups

  # Mensagens enviadas
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy

  # Métodos auxiliares
  def to_s
    email_address
  end

  # Todas as conversas do usuário
  def conversations
    Conversation.where("user1_id = ? OR user2_id = ?", id, id)
      .includes(:messages)
      .order("messages.created_at DESC")
  end
  
  # Encontra ou cria conversa com outro usuário
  def conversation_with(user)
    Conversation.find_by("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)", 
                       id, user.id, user.id, id) ||
    Conversation.create(user1: self, user2: user)
  end

  # Mensagens não lidas em todas as conversas
  def unread_messages
    Message.joins(:conversation)
           .where("(conversations.user1_id = :user_id OR conversations.user2_id = :user_id)", user_id: id)
           .where(unread: true)
           .where.not(sender_id: id)
  end

  # Contagem de mensagens não lidas
  def unread_messages_count
    unread_messages.count
  end

  # Conversas com mensagens não lidas
  def conversations_with_unread_messages
    conversations.joins(:messages)
                 .where(messages: { unread: true })
                 .where.not(messages: { sender_id: id })
                 .distinct
  end

  # Contagem de mensagens não lidas por conversa
  def unread_counts_by_conversation
    conversations.left_joins(:messages)
                 .where(messages: { unread: true })
                 .where.not(messages: { sender_id: id })
                 .group('conversations.id')
                 .count('messages.id')
  end
end