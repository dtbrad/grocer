class SessionsController < ApplicationController
  def create
    if params[:email] == 'sampleuser@mail.com'
      user = User.find_by(email: 'sampleuser@mail.com')
    else
      user = User.from_omniauth(env['omniauth.auth'])
    end
    session[:user_id] = user.id
    redirect_to baskets_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
