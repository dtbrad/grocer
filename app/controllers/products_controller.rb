class ProductsController < ApplicationController

  def index
    @products = current_user.products.distinct.sort_by{|p| p.name} unless !current_user
  end

  def show
    @user = current_user
    @product = Product.find(params[:id])
    if !@user.products.distinct.include?(@product)
      redirect_to products_path,  flash: { alert: "You can only view products you have purchased" }
    end
  end

end
