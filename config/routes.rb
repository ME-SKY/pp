Rails.application.routes.draw do

  devise_for :users
  resources :posts
  resources :attachments


  root 'front#index'

  post 'auth_user' => 'authentication#authenticate_user'
  get 'posts' => 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
