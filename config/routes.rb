Rails.application.routes.draw do
  get "moves/create"

  get "build_player_field", to: "game_sessions#build_player_field", as: :build_player_field
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "pages#home"
  resources :users, only: [:show]
  resources :games, only: [:show] do
    resources :game_sessions, only: [:new, :create]
  end

  resources :session_players, only: [:new, :create]
  resources :score_sheets, only: [:show, :create] do
    member do
      post :end_game
      get :results
      patch :first_player
    end
    resources :rounds, only: [:create]
  end
  resources :rounds, only: [:edit, :update]
  resources :moves, only: [:create]
end
