class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def welcome
  end

  private

  def current_user
    if User.find_by(id: session[:user_id])
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
end
