Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :shopping_lists
  resources :baskets
  resources :products

  root 'baskets#index'
  get 'welcome', to: 'application#welcome'

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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
