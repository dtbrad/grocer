class BasketsController < ApplicationController

  def index
    if current_user
      @baskets = current_user.baskets.all
    end
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
    current_user.baskets.each { |b| b.products.destroy_all }
    current_user.baskets.each { |b| b.line_items.destroy_all }
    current_user.baskets.destroy_all
    redirect_to baskets_path
  end
end
