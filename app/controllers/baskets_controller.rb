class BasketsController < ApplicationController

  def index
    @baskets = Basket.all
  end

  def new
  end

  def create
    binding.pry
  end
end
