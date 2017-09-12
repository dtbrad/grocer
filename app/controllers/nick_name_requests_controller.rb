class NickNameRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @nick_name_requests = NickNameRequest.where(status: 'unreviewed')
      @users_without_baskets = User.where('id NOT IN (SELECT DISTINCT(user_id) FROM baskets)')
      @users_with_baskets = User.group('users.id').joins(:baskets).order('MAX(baskets.created_at) desc')
      @baskets = Basket.where(fishy_total: true)
    else
      redirect_to root_path, flash: { alert: 'You do not have access to this page' }
    end
  end

  def become
    return unless current_user.admin?
    sign_in(:user, User.find(params[:id]), bypass: true)
    redirect_to root_url
  end

  def create; end

  def update
    return unless current_user.admin?
    @nick_name_request = NickNameRequest.find(params[:id])
    NickNameRequest.process_request(@nick_name_request, params)
    redirect_to nick_name_requests_path
  end
end
