# frozen_string_literal: true

Rails.application.routes.draw do
  resources :sessions
  delete :logout, to: 'sessions#destroy', as: :logout
  resources :passwords, param: :token
  resources :registrations, only: %i[new create]
  resources :groups, only: :create
  resources :messages, only: [ :create, :index ] do
    collection do
      put :mark_as_read
    end
  end

  root "home#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  namespace :api do
    resources :messages, only: [ :index ]
    post "sign_up", to: "registrations#create", as: :sign_up
    post "sign_in", to: "sessions#create", as: :sign_in
    delete "logout", to: "sessions#destroy", as: :logout
  end
end
