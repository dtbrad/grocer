class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_domain
  helper_method :set_graph, :sort_column, :sort_direction

  def about; end

  def privacy; end

  def tos; end

  def welcome; end

  def log_out_to_register
    reset_session
    redirect_to new_user_registration_path
  end

  def set_graph
    @graph_config =
      if params[:graph_config]
        GraphConfig.new(graph_config_params)
      else
        GraphConfig.new(start_date: params[:start], end_date: params[:end], unit: params[:unit])
      end
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  private

  def ensure_domain
    return if request.env['HTTP_HOST'] == ENV['WEB_URL'] || Rails.env.development?
    redirect_to "https://#{ENV['WEB_URL']}", status: 301
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  def set_vary_header
    return if request.xhr?
    response.headers['Vary'] = 'accept'
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
