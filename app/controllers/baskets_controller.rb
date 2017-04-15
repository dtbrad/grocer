class BasketsController < ApplicationController
  helper_method :unit, :duration, :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    if current_user
      @baskets = current_user.baskets.from_graph(unit, duration).custom_sort(sort_column, sort_direction)
      .page params[:page]
      @unpaginated_unsorted_baskets = current_user.baskets.from_graph(unit, duration)
      respond_to do |format|
        format.html
        format.js
      end
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
  end

  def remove
    current_user.baskets.remove_user
    redirect_to baskets_path, flash: { alert: 'Purchase history deleted from your account' }
  end

  private

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end


  def unit
    params[:unit] ? params[:unit] : "months"
  end

  def duration
    params[:duration] ? params[:duration] : 12
  end

end
