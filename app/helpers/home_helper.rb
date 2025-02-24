module HomeHelper
  def chat_with
    @chat_with ||= Current.user.chat_with(@receiver)
  end
end
