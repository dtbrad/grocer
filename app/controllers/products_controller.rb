class ProductsController < ApplicationController
  def index
    @products = current_user.products.order(:name).distinct
    # @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end
end
