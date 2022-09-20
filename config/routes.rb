Rails.application.routes.draw do
  devise_for :users

  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
  post "/homes/guest_sign_in", to: "homes#new_guest"
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end
  get "users/withdraw/:id" => "users#withdraw", as: "users_withdraw"
  resources :chats, only: [:create]
  get "chat/:id" => "chats#show", as: "chat"
  resources :notifications, only: [:index]
end
