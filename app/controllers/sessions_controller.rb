# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    # Garanta que usuários autenticados não vejam esta página
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for(user)
      redirect_to after_authentication_url, notice: "Signed in successfully!"
    else
      # Mantém o email digitado para melhor UX
      flash.now[:alert] = "Try another email address or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Signed out successfully!"
  end
end
