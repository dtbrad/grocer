Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    authenticated :user do
      root :to => 'application#welcome'
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end
  resources :shopping_lists, only: [:index, :show, :create]
  resources :baskets
  resources :products

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
end
