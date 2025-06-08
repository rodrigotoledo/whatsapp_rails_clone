# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    if params[:message][:messageable_type] == 'User'
      # Para mensagens diretas (1:1)
      receiver = User.find(params[:message][:messageable_id])
      @conversation = Current.user.conversation_with(receiver)
      @message = @conversation.messages.new(
        content: message_params[:content],
        sender_id: Current.user.id
      )
    else
      # Para mensagens em grupo (se ainda estiver usando)
      @message = Current.user.sent_messages.new(message_params)
    end

    if @message.save
      update_conversation_timestamp if @conversation

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to appropriate_redirect_path, notice: "Message sent successfully!" }
      end
    else
      redirect_to root_path, alert: @message.errors.full_messages.to_sentence
    end
  end

  def mark_as_read
    @conversation = Current.user.conversations.find(params[:id])
    @conversation.messages.where(unread: true, sender_id: !Current.user.id).update_all(unread: false)

    respond_to do |format|
      format.turbo_stream { render partial: "unread_messages", locals: { user: Current.user } }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :messageable_id, :messageable_type)
  end

  def update_conversation_timestamp
    @conversation.update(last_message_at: Time.current)
  end

  def appropriate_redirect_path
    if @message.messageable_type == 'User'
      chat_path(user_id: @message.messageable_id)
    else
      root_path(group_id: @message.messageable_id)
    end
  end
end
