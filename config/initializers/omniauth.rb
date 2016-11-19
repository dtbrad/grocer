OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'], {
    scope: ['https://mail.google.com/', 'email'],
    # scope: ['https://www.googleapis.com/auth/gmail.readonly', 'https://www.googleapis.com/auth/userinfo.email'],
    # scope: ['https://www.googleapis.com/auth/gmail.readonly', 'email'],
    # works with the present scope but cannot get commented out read-only scope
    # to work! in my basket.rb file it breaks at line 7, showing that I'm disconnected
    prompt: 'select_account'
    }
end


    # scope: ['https://mail.google.com/', 'email'],
