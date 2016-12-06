class ProductsController < ApplicationController

  def index
    @products = current_user.products.order(:name) unless !current_user
  end

  def show
    @product = Product.find(params[:id])
  end
end
