class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_domain

  def about
  end

  def privacy
  end

  def tos
  end

  def welcome
  end

  def log_out_to_register
    reset_session
    redirect_to new_user_registration_path
  end

  private

  def ensure_domain
    unless request.env['HTTP_HOST'] == ENV['WEB_URL'] || Rails.env.development?
      redirect_to "https://#{ENV['WEB_URL']}", :status => 301
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  def set_vary_header
    if request.xhr?
      response.headers["Vary"] = "accept"
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
