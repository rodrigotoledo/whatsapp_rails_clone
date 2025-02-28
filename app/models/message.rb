class Message < ApplicationRecord
  attr_accessor :receiver_type

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :group, optional: true
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id", optional: true

  validates :sender, :content, :receiver_type, presence: true
  validate :validate_receiver

  after_create :add_friendships, :broadcast_unread_messages

  def read_message!
    update(unread: false)
  end

  private

  def broadcast_unread_messages
    broadcast_update_to(
      [receiver, "unread_messages"],
      target: "unread_messages",
      partial: "messages/unread_messages",
      locals: {user: receiver}
    )
  end

  def add_friendships
    return if sender_id == receiver_id
    return if group_id.present?

    receiver.friends << sender unless receiver.friends.include?(sender)

    return if sender.friends.include?(receiver)

    sender.friends << receiver
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
