class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @products = current_user.products.filtered_products.
      custom_sort(sort_column, sort_direction).
      paginate(page: params[:page], per_page: 10) unless !current_user
  end

  def show
    @user = current_user
    @product = Product.find(params[:id])
    if !@user.products.distinct.include?(@product)
      redirect_to products_path,  flash: { alert: "You can only view products you have purchased" }
    end
  end

  private

  def sort_column
    params[:sort]
  end

  def sort_direction
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
