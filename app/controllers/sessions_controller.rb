class SessionsController < ApplicationController
  def create
    user = if params[:email] == 'sampleuser@mail.com'
             User.find_by(email: 'sampleuser@mail.com')
           else
             User.from_omniauth(env['omniauth.auth'])
           end
    session[:user_id] = user.id
    redirect_to baskets_path, flash: { notice: 'Now logged in' }
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: { notice: 'Now logged out' }
  end
end
