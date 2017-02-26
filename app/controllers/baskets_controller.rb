class BasketsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    if current_user
      @baskets = current_user.baskets.custom_sort(sort_column, sort_direction)
      .page params[:page]
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def new
    redirect_to baskets_path unless current_user.id != 100
  end

  def show
    @basket = Basket.find(params[:id])
    if @basket.user != current_user
      redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
    end
  end

  # def attach_google
  #
  # end
  def create
    # binding.pry
    if !current_user.oauth_token
      redirect_to baskets_path, flash: { alert: 'You need to log in via oauth' }
    else
    # if Scraper.grab_emails(current_user, params[:date]).length > 0
      # BasketWorker.perform_async(current_user.id, params[:date])
     if Scraper.process_emails(current_user, params[:date])
      redirect_to baskets_path, flash: { notice: 'Purchase History Loaded' }
    else
      redirect_to baskets_path, flash: { alert: 'You have no receipts in your inbox' }
    end
  end
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
