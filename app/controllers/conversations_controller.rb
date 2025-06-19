# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :set_conversation, only: [ :show, :mark_as_read ]

  def show
    mark_messages_as_read
    @messages = @conversation.messages.order(created_at: :asc)
  end

  def index
  end

  def mark_as_read
    mark_messages_as_read
    head :ok
  end

  private
  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def mark_messages_as_read
    @conversation.mark_as_read_for(current_user)
  end
end
