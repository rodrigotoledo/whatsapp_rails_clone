module MessagesHelper
  def unread_messages_for_user(user)
    user.unread_messages.count
  end
end
