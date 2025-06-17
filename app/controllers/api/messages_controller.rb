# frozen_string_literal: true

module Api
  class MessagesController < Api::ApplicationController
    before_action :authenticate_user!
    def index
      render json: current_user.messages.to_json
    end
  end
end
