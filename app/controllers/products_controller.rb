class ProductsController < ApplicationController
  include ApplicationHelper
  # this includes helper_method :sort_column, :sort_direction, :set_graph
  before_action :set_variables, only: %i[show update]
  before_action :authenticate_user!, except: :product_summaries

  def index
    @products = current_user.products.filtered_products.search(params[:search])
                            .custom_sort(sort_column, sort_direction).page params[:page]
  end

  def show
    spending_state = SpendingState.new(params)
    @graph_config = spending_state.set_graph
    @line_items = @product.this_users_line_items(current_user)
                          .from_graph(@graph_config).custom_sort(sort_column, sort_direction)
                          .page params[:page]
  end

  def create; end

  def update
    Product.process_nick_name_request(@user, @product, params)
  end

  def product_summaries
    @products = Product.filtered_products.search(params[:search])
    render json: @products.limit(15).order(:nickname)
  end

  private

  def set_variables
    @user = current_user
    @product = Product.find(params[:id])
  end

  def graph_config_params
    params.require(:graph_config).permit(:start_date, :end_date, :unit, :graph_change)
  end
end
