class BasketsController < ApplicationController
  def index
    @baskets = current_user.baskets.all unless !current_user
  end

  def new
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
