class ProductsController < ApplicationController

  def index
    @products = current_user.products.distinct.sort_by{|p| p.name} unless !current_user
  end

  def show
    @user = current_user
    @product = Product.find(params[:id])
  end
end
