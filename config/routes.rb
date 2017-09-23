Rails.application.routes.draw do
  resources :tokens, only: [:create]
  resources :public_keys, only: [:index]
  resources :users, only: [:show] do
    # resources :memberships, only: [:index, :create, :destroy]
  end
  resources :groups, only: [:create, :update, :show] do
    resource :code, only: [:update]
  end

  root to: 'static#index'
end
