class Message < ApplicationRecord
  attr_accessor :receiver_type

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :group, optional: true
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id", optional: true

  validates :sender, :content, :receiver_type, presence: true
  validate :validate_receiver

  after_create :add_friendships_and_broadcast, :broadcast_friend_unread_messages, :broadcast_friend_append_message, if: -> { receiver.present? }
  after_create :broadcast_group_append_message, if: -> { group.present? }

  def read_message!
    update(unread: false)
  end

  private

  def add_friendships_and_broadcast
    return if sender_id == receiver_id

    receiver.friends << sender unless receiver.friends.include?(sender)
    sender.friends << receiver unless sender.friends.include?(receiver)

    broadcast_update_to(
      [receiver, "friendships"],
      target: "friendships",
      partial: "friendships/friendship",
      locals: {user: receiver}
    )
  end

  def broadcast_friend_unread_messages
    broadcast_update_to(
      [receiver, "unread_messages"],
      target: "unread_messages",
      partial: "messages/unread_messages",
      locals: {user: receiver}
    )
  end

  def broadcast_friend_append_message
    broadcast_append_to(
      [receiver, "messages_box"],
      target: "messages_box",
      partial: "messages/message",
      locals: {message: self}
    )
  end

  def broadcast_group_append_message
    broadcast_append_to(
      [group, "messages_box"],
      target: "messages_box",
      partial: "messages/message",
      locals: {message: self}
    )
  end

  def validate_receiver
    case receiver_type
    when "Group"
      errors.add(:group_id, "must be present when receiver is a Group") if group_id.blank?
    when "User"
      errors.add(:receiver_id, "must be present when receiver is a User") if receiver_id.blank?
    else
      errors.add(:receiver_type, "is invalid")
    end
  end
end
