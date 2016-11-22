class ProductsController < ApplicationController
  def index
    @products = current_user.products.all unless !current_user
  end

  def show
    @product = Product.find(params[:id])
  end
end
