class BasketsController < ApplicationController
  # before_action: current_user = current_user || User.find(100)
  def index
    @baskets = current_user.baskets.order(:date) unless !current_user
  end

  def new
    redirect_to baskets_path unless current_user.id != 100
  end

  def show
    @basket = Basket.find(params[:id])
  end

  def create
    Basket.create_basket(current_user, params[:date])
    redirect_to baskets_path
  end

  def remove
    current_user.baskets.destroy_all
    redirect_to baskets_path
  end
end
