class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_variables, only: [:show, :update]
  before_filter :auth_user

  def index
      if params[:search]
        @products = current_user.products.filtered_products.search(params[:search])
          .custom_sort(sort_column, sort_direction).page params[:page]
      else
        @products = current_user.products.filtered_products
          .custom_sort(sort_column, sort_direction).page params[:page]
      end
  end

  def show
    if !@user.products.include?(@product)
      redirect_to products_path,
      flash: { alert: 'You can only view products you have purchased' }
    end
  end

  def create; end

  def update
    if current_user.admin?
      @product.update(nickname: params[:product][:nickname])
    end
  end

  def product_summaries
    render json: Product.filtered_products
  end

  private

  def set_variables
    @user = current_user
    @product = Product.find(params[:id])
    @line_items = @product.this_users_line_items(@user)
                          .custom_sort(sort_column, sort_direction)
                          .page params[:page]
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
