# frozen_string_literal: true

module MessagesHelper
  def unread_messages_for_user(user)
    user.unread_messages_count
  end

  def conversation_title(conversation)
    if conversation.group?
      conversation.group.name
    else
      other_user = conversation.participants.where.not(id: current_user.id).first
      other_user.email_address # ou other_user.name se tiver
    end
  end

  def current_conversations(user)
    @conversations ||= user.conversations.includes(:participants, :messages).order(updated_at: :desc)
  end

  def unread_count_for(conversation, user)
    conversation.unread_count_for(user)
  end
end
