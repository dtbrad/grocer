Rails.application.routes.draw do
  resources :baskets
  resources :products

  root 'baskets#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'remove', to: 'baskets#remove', as: 'remove'

  get 'monthly_spending_chart', to: 'charts#monthly_spending'
  get 'weekly_spending_chart', to: 'charts#weekly_spending'
  get 'most_spent_chart', to: 'charts#most_spent'
  get 'most_bought_chart', to: 'charts#most_bought'
  get 'product_monthly_purchasing_chart', to: 'charts#product_monthly_purchasing'
  get 'product_weekly_purchasing_chart', to: 'charts#product_weekly_purchasing'

  get 'product_summaries', to: 'products#product_summaries'

  get 'listmaker', to: 'angular#angular'
  get 'listmaker/*all', to: 'angular#angular'

  # get 'listmaker/all', to: 'angular#angular'
  #
  # get 'listmaker/new', to: 'angular#angular'

  resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
