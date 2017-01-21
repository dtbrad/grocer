class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_product, only: [:show, :update]

  def index
    if current_user
      @products = current_user.products.filtered_products
                              .custom_sort(sort_column, sort_direction)
                              .paginate(page: params[:page], per_page: 15)
    end
  end

  def show
    @user = current_user
    @line_items = @product.this_users_line_items(@user)
                          .custom_sort(sort_column, sort_direction)
                          .paginate(page: params[:page], per_page: 10)
    if !@user.products.distinct.include?(@product)
      redirect_to products_path,
      flash: { alert: 'You can only view products you have purchased' }
    end
  end

  def create; end

  def update
    @product.update(nickname: params[:product][:nickname])
    redirect_to product_path(@product), flash: { notice: 'Product name updated' }
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
