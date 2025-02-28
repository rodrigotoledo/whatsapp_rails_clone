module HomeHelper
  def chat_with
    @chat_with ||= Current.user.chat_with(@receiver)
  end

  def receiver_message_box
    @receiver.is_a?(Group) ? @receiver : Current.user
  end
end
