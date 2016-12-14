class BasketsController < ApplicationController
  def index
    @baskets = current_user.baskets.order(:date) unless !current_user
  end

  def new
    redirect_to baskets_path unless current_user.id != 100
  end

  def show
    @basket = Basket.find(params[:id])
    if @basket.user != current_user
      redirect_to baskets_path,  flash: { alert: "You can only view your own baskets" }
    end
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
