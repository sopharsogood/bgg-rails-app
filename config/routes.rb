Rails.application.routes.draw do
  resources :boardgames, only: [:show, :index]
  resources :genres, only: [:show, :index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
