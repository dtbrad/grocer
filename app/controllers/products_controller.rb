class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @products = current_user.products.filtered_products.custom_sort(sort_column, sort_direction).
    paginate(page: params[:page], per_page: 15) unless !current_user
  end

  def show
    @user = current_user
    @product = Product.find(params[:id])
    @line_items = @product.this_users_line_items(@user)
    if !@user.products.distinct.include?(@product)
      redirect_to products_path,  flash: { alert: "You can only view products you have purchased" }
    end
  end

  def create
    binding.pry
  end

  def update
    @product = Product.find(params[:id])
    @product.update(nickname: params[:product][:nickname])
    redirect_to product_path(@product)
  end

  private

  def sort_column
    params[:sort]
  end

  def sort_direction
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
