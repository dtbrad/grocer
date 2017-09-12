class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :my_user, only: %i[index show update]
  before_action :set_product, only: %i[show update]
  before_action :authenticate_user!, except: %i[product_summaries index show update]

  def index
    return unless @my_user
    @products = @my_user.products.filtered_products.search(params[:search])
                        .custom_sort(sort_column, sort_direction).page params[:page]
  end

  def show
    return unless @my_user
    sorted_line_items = @product.this_users_line_items(@my_user).joins(:basket).order("baskets.date")
    @spending_state = SpendingState.new(my_user, sorted_line_items, params)
    @graph_config = @spending_state.set_graph
    @line_items = @product.this_users_line_items(@my_user)
                          .from_graph(@graph_config)
                          .custom_sort(@spending_state.sort_column, @spending_state.sort_direction)
                          .page params[:page]
  end

  def create; end

  def update
    return unless @my_user
    Product.process_nick_name_request(my_user, @product, params)
  end

  def product_summaries
    @products = Product.filtered_products.search(params[:search])
    render json: @products.limit(15).order(:nickname)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def sort_column
    params[:sort] || 'sort_nickname'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
