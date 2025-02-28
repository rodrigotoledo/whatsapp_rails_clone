class MessagesController < ApplicationController
  def create
    @message = Current.user.sent_messages.new(message_params)

    if @message.save
      redirect_to root_path(group_id: @message.group_id, friend_id: @message.receiver_id), notice: "Message sent successfully!"
    else
      redirect_to root_path, alert: @message.errors.full_messages.to_sentence
    end
  end

  def mark_as_read
    Current.user.unread_messages.update_all(unread: false)
    render partial: "unread_messages", locals: {user: Current.user}
  end

  private

  def message_params
    params.require(:message).permit(:content, :group_id, :receiver_id, :receiver_type).merge(sender_id: Current.user.id)
  end
end
