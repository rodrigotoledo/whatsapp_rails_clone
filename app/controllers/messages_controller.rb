# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_conversation

  def index
    @messages = @conversation.messages.order(created_at: :asc)
  end

  def create
    @message = @conversation.messages.new(message_params.merge(sender: current_user))

    if @message.save
      redirect_to conversation_path(@conversation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
