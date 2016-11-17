class BasketsController < ApplicationController

  def index
    if current_user
      @baskets = current_user.baskets.all
    else
      @baskets = Basket.all
    end
  end

  def new
  end

  def show
    @basket = Basket.find(params[:id])
  end

  def create
    Basket.create_basket(current_user, params[:num])
    redirect_to baskets_path
  end
end
