class BasketsController < ApplicationController

  def index
    @baskets = Basket.all
  end

  def new
  end

  def show
    @basket = Basket.find(params[:id])
  end

  def create
    Basket.create_basket(params[:username], params[:password])
    redirect_to baskets_path
  end
end
