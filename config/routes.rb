Rails.application.routes.draw do
  get "game_sessions/new"
  get "game_sessions/create"
  get "games/show"
  get "pages/home"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "pages#home"
  resources :games, only: [:show] do
    resources :game_sessions, only: [:new, :create]
  end
end
