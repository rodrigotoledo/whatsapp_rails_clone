# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]
  resource :groups, only: :create

  resources :conversations, only: [ :index, :show ] do
    member do
      patch :mark_as_read
    end
    # Mensagens aninhadas sob conversas
    resources :messages, only: [ :index, :create ]

    # Rotas adicionais para conversas
    member do
      post :add_participant
      delete :remove_participant
    end
  end

  # Rotas independentes para friendships
  resources :friendships, only: [ :index, :create, :destroy ] do
    collection do
      get :pending
      put :accept
    end
  end

  # Rotas para grupos (se ainda necessário)
  resources :groups, only: [ :create, :show, :update, :destroy ] do
    member do
      post :join
      post :leave
    end
  end

  root "conversations#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  namespace :api do
    post "sign_up", to: "registrations#create", as: :sign_up
    post "sign_in", to: "sessions#create", as: :sign_in
    delete "logout", to: "sessions#destroy", as: :logout
    resources :messages, only: [ :index, :create ] do
      collection do
        put :mark_as_read
      end
    end
  end
end
