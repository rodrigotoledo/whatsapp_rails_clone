Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]
  resource :groups, only: :create
  resource :messages, only: :create do
    collection do
      put :mark_as_read
    end
  end

  root "home#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  namespace :api do
    post "sign_up", to: "registrations#create", as: :sign_up
    post "sign_in", to: "sessions#create", as: :sign_in
    delete "logout", to: "sessions#destroy", as: :logout
  end
end
