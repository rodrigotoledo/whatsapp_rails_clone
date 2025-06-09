# app/serializers/message_serializer.rb
class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :unread, :created_at

  belongs_to :sender, serializer: UserSerializer
  belongs_to :receiver, serializer: UserSerializer
  belongs_to :group, serializer: GroupSerializer
end
