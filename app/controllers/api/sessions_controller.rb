# frozen_string_literal: true

module Api
  class SessionsController < Api::ApplicationController
    def create
      data = params.permit(:email_address, :password)
      user = User.find_by(email_address: data[:email_address])
      if user&.authenticate(data[:password])
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
