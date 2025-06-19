# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :conversation_participants
  has_many :participants, through: :conversation_participants, source: :user
  has_many :messages
  has_one :group, inverse_of: :conversation
  scope :only_groups, -> { where(conversation_type: "group") }

  validates :group, presence: true, if: :group?

  def mark_as_read_for(user)
    transaction do
      participant = conversation_participants.find_by(user: user)
      participant.update!(last_read_at: Time.current)

      user.touch if user.respond_to?(:touch)
    end
  end

  def display_name(current_user)
    if group?
      group.name
    else
      other_user = participants.where.not(id: current_user.id).first
      return unless other_user
      other_user.email_address
    end
  end

  def group?
    conversation_type == "group"
  end

  def group
    super if group?
  end

  def unread_count_for(user)
    ConversationParticipant.where(user_id: user.id)
      .joins(conversation: :messages)
      .where("messages.conversation_id = ?", id)
      .where("messages.sender_id != ?", user.id)
      .where("messages.created_at > COALESCE(conversation_participants.last_read_at, TIMESTAMP '1970-01-01')")
      .count
  end
end
