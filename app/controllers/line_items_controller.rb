class LineItemsController < ApplicationController
  helper_method :unit, :start_date, :end_date, :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :set_product

  def index
    return unless current_user
    @user = current_user
    respond_to do |format|
      format.html do
        @graph_config = GraphConfig.new
        @line_items = @product.this_users_line_items(current_user).from_graph(@graph_config).page params[:page]
        @coll = current_user.line_items.where(product: @product)
      end
      format.js do
        @coll = current_user.line_items.where(product: @product)
        set_up_state
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def graph_config_params
    params.require(:graph_config).permit(:start_date, :end_date, :unit, :graph_change)
  end

  def set_up_state
    set_graph
    set_table
  end

  def set_graph
    @graph_config =
      if params[:graph_config]
        GraphConfig.new(graph_config_params)
      else
        GraphConfig.new(start_date: params[:start], end_date: params[:end], unit: params[:unit])
      end
  end

  def set_table
    @line_items = @product.this_users_line_items(current_user)
                          .from_graph(@graph_config).custom_sort(sort_column, sort_direction)
                          .page params[:page]
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
