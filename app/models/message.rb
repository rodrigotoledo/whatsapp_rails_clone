# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"
  has_many :message_read_statuses

  validates :sender, :content, presence: true

  after_create :broadcast_append_message

  private

  def broadcast_append_message
    broadcast_append_to(
      conversation,
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )

    conversation.participants.each do |user|
      broadcast_update_to(
        [ user, "conversations_list" ],
        target: "conversations_list",
        partial: "conversations/list",
        locals: { user: user }
      )

      broadcast_update_to(
        [ user, "unread_messages" ],
        target: "unread_messages",
        partial: "messages/unread_messages",
        locals: { user: user }
      )
    end
  end
end
