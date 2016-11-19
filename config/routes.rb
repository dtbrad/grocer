Rails.application.routes.draw do
  resources :baskets
  resources :products

  root 'baskets#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'remove', to: 'baskets#remove', as: 'remove'

resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
