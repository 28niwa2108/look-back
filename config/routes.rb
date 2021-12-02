Rails.application.routes.draw do
  root to: 'subscriptions#index'
  devise_for :users
  resources :users, only: [:show] do
    resources :subscriptions, only: [:show, :new, :create, :edit, :update, :destroy]    
  end
end
