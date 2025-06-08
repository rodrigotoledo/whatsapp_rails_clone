class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, as: :messageable

  def other_user(current_user)
    user1 == current_user ? user2 : user1
  end
end
