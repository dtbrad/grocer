class BasketsController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html do
        @graph_config = GraphConfig.new
        @baskets = current_user.baskets.from_graph(@graph_config).page params[:page]
      end
      format.js do
        set_up_state
      end
    end
  end

  def new; end

  def show
    @basket = Basket.find(params[:id])
    return if @basket.user == current_user
    redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
  end

  def create
    BasketWorker.perform_async(current_user.id, params[:date], session[:access_token], params[:orig_email])
    # Scraper.process_emails(current_user, params[:date], session[:access_token], params[:orig_email])
  end

  def disassociate_user
    current_user.disassociate_baskets
    redirect_to baskets_path, flash: { alert: 'Purchase history deleted from your account' }
  end

  private

  def graph_config_params
    params.require(:graph_config).permit(:start_date, :end_date, :unit, :graph_change)
  end

  def set_up_state
    # set_graph is inside ApplicationController
    set_graph
    set_table
  end

  def set_table
    # sort_column and sort_direction are in ApplicationController
    @baskets = current_user.baskets.from_graph(@graph_config).custom_sort(sort_column, sort_direction)
                           .page params[:page]
  end
end
