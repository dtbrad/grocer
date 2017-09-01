class GoogleApiController < ApplicationController
  before_action :authenticate_user!

  def go_to_google
    client = Signet::OAuth2::Client.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::GmailV1::AUTH_GMAIL_READONLY,
      redirect_uri: ENV['redirect_uri'],
      prompt: 'select_account consent'
    )
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_SECRET'],
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: ENV['redirect_uri'],
      code: params[:code]
    )
    response = client.fetch_access_token!
    session[:access_token] = response['access_token']
    redirect_to grab_gmails_path
  end

  def grab_gmails
    BasketWorker.perform_async(current_user.id, session[:access_token])
    # GoogleApi.process_api_request(current_user, session[:access_token])
  end
end
