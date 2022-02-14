Rails.application.routes.draw do
  root to: 'subscriptions#index'
  devise_for :users, :controllers => { :registrations => :registrations }
  resources :users, only: [:show] do
    resources :contract_cancels, only: [:index]
    resources :reviews, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
      collection do
        get 'all_index'
      end
    end
    resources :subscriptions, only: [:show, :new, :create, :edit, :update, :destroy] do
      resources :contract_renewals, only: [:update]
      resources :contract_cancels, only: [:new, :create]
      resources :reviews, only: [:index, :show, :edit, :update]
    end
  end
end
