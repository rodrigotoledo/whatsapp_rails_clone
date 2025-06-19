# frozen_string_literal: true

class Group < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :conversation
  before_validation :ensure_conversation
  has_many :group_memberships
  has_many :users, through: :group_memberships
  validates :name, presence: true

  def to_s
    name
  end

  def add_member(user)
    conversation.participants << user unless conversation.participant_ids.include?(user.id)
  end

  private
  def ensure_conversation
    build_conversation(conversation_type: "group") unless conversation
  end
end
