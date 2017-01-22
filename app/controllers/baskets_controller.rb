class BasketsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    if current_user
      @baskets = current_user.baskets.custom_sort(sort_column, sort_direction)
      .paginate(page: params[:page], per_page: 15)
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

  def create
    Basket.create_basket(current_user, params[:date])
    redirect_to baskets_path, flash: { notice: 'Purchase History Loaded' }
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
