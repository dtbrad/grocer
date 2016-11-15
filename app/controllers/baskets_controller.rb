class BasketsController < ApplicationController

  def index
    @baskets = Basket.all
  end

  def new
  end

  def create
    Basket.create_basket(params[:username], params[:password])
    binding.pry
    redirect_to baskets_path
  end
end
