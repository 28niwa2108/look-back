Rails.application.routes.draw do
  root to: 'subscriptions#index'
  devise_for :users
  resources :users, only: [:show] do
    resources :reviews, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
      collection do
        get 'all_index'
      end
    end
    resources :subscriptions, only: [:show, :new, :create, :edit, :update, :destroy] do
      resources :contract_renewals, only: [:update]
      resources :reviews, only: [:index, :show, :edit, :update]
    end
  end
end
