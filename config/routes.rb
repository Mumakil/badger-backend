Rails.application.routes.draw do
  resources :tokens, only: [:create]
  resources :public_keys, only: [:index]
  resources :users, only: [:show] do
    resources :groups, only: [:index]
  end
  resources :groups, only: [:create, :update, :show] do
    resource :code, only: [:update]
    resources :members, only: [:index, :destroy]
  end
  resources :memberships, only: [:create], controller: :members

  root to: 'static#index'

  match '/', to: 'application#no_route_found', via: [:post, :patch, :put, :delete]
  match '*path', to: 'application#no_route_found', via: :all
end
