# frozen_string_literal: true

module Api
  class SessionsController < Api::ApplicationController
    def create
      user = User.find_by(email_address: params.permit(:email_address))
      if user&.authenticate(params.permit(:password))
        token = login(user)
        render json: { user: user.attributes.except("password_digest"), token: token }, status: :created
      else
        head :unprocessable_entity
      end
    end

    def destroy
      logout current_user
      head :no_content
    end
  end
end
