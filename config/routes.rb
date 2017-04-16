Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    authenticated :user do
      root :to => 'baskets#index'
    end
    unauthenticated :user do
      root :to => 'application#welcome', as: :unauthenticated_root
    end
  end
  resources :shopping_lists, only: [:show, :index, :create]
  resources :baskets
  resources :products
  resources :nick_name_requests

  get 'welcome', to: 'application#welcome'
  get 'privacy', to: 'application#privacy'
  get 'remove', to: 'baskets#remove', as: 'remove'
  get 'basket_spending_chart', to: 'charts#basket_spending'
  get 'most_spent_chart', to: 'charts#most_spent'
  get 'most_bought_chart', to: 'charts#most_bought'
  get 'product_monthly_purchasing_chart', to: 'charts#product_monthly_purchasing'
  get 'product_weekly_purchasing_chart', to: 'charts#product_weekly_purchasing'
  get 'product_summaries', to: 'products#product_summaries'

  get 'listmaker', to: 'angular#angular'
  get 'listmaker/*all', to: 'angular#angular'

  get 'import', to: 'google_api#go_to_google', as: 'import_path'
  get 'auth/:provider/callback', to: 'google_api#callback'

  mount ActionCable.server => '/cable'

end
