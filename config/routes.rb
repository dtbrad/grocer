Rails.application.routes.draw do
  resources :baskets
  resources :products

  root 'baskets#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
