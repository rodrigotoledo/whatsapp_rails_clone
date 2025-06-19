# frozen_string_literal: true

class MessageReadStatus < ApplicationRecord
  belongs_to :message
  belongs_to :user
end
