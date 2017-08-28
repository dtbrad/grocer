Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'application#welcome'
  resources :shopping_lists, only: %i[show index create]
  resources :baskets, only: %i[index new show create]
  resources :baskets do
    collection do
      delete :destroy_all
    end
  end
  resources :products, only: %i[index show create update]
  resources :nick_name_requests, only: %i[index create update]

  get 'about', to: 'application#about'
  get 'welcome', to: 'application#welcome'
  get 'tos', to: 'application#tos'
  get 'privacy', to: 'application#privacy'
  get 'sample_user_message', to: 'application#sample_user_message'
  get 'log_out_to_register', to: 'application#log_out_to_register'

  get 'product_summaries', to: 'products#product_summaries'

  get 'listmaker', to: 'angular#angular'
  get 'listmaker/*all', to: 'angular#angular'

  get 'import', to: 'google_api#go_to_google', as: 'import_path'
  get 'auth/:provider/callback', to: 'google_api#callback'

  post 'send_password_email', to: 'application#send_password_email'

  post 'mailgun', to: 'mail_gun#process_mail_gun_post_request'

  mount ActionCable.server => '/cable'
end
