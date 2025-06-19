# frozen_string_literal: true

module Api
  class MessagesController < Api::ApplicationController
    before_action :authenticate_user!
    before_action :set_receiver, only: :index

    def index
      render json: { messages: current_user.messages }, status: :ok
    end

    def create
      message = current_user.messages.build(message_params)

      if message.save
        head :created
      else
        render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:content, :group_id, :receiver_id).merge(sender_id: current_user.id)
    end

    def set_receiver
      return if params[:group_id].blank? && params[:friend_id].blank?

      @receiver = if params[:group_id].present?
                    current_user.groups.find_by(id: params[:group_id])
      elsif params[:friend_id].present?
                    current_user.friends.find_by(id: params[:friend_id])
      end
    end
  end
end
