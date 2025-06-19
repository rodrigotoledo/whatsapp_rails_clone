# frozen_string_literal: true

class GroupMembership < ApplicationRecord
  self.table_name = "groups_users"
  belongs_to :group
  belongs_to :user
  # Você pode adicionar atributos extras como 'role', 'joined_at', etc.
end
