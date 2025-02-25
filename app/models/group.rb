class Group < ApplicationRecord
  validates :name, presence: true
  has_many :messages, dependent: :destroy

  def to_s
    name
  end
end
