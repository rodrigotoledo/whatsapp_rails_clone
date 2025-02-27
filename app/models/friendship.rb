class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user, :friend, presence: true
  validate :user_is_not_friend

  private

  def user_is_not_friend
    errors.add(:friend, "can't be the same as user") if user == friend
  end
end
