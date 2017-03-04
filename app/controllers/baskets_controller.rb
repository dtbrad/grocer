class BasketsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    if current_user
      @baskets = current_user.baskets.custom_sort(sort_column, sort_direction)
      .page params[:page]
    end
  end

  def new
  end

  def show
    @basket = Basket.find(params[:id])
    if @basket.user != current_user
      redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
    end
  end

  def create
    BasketWorker.perform_async(current_user.id, params[:date], session[:access_token])
    # Scraper.process_emails(current_user, params[:date], session[:access_token])
    redirect_to baskets_path, flash: { success: 'Your purchase history is now importing in the background. It could take a few minutes' }
  end

  def remove
    current_user.baskets.destroy_all
    redirect_to baskets_path, flash: { alert: 'Purchase History Deleted' }
  end

  private

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

end
