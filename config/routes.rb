Rails.application.routes.draw do
  resources :tokens, only: [:create]
  resources :public_keys, only: [:index]
end
