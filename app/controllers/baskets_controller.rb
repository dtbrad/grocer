class BasketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @spending_state = SpendingState.new(params)
    @graph_config = @spending_state.set_graph
    @baskets = current_user.baskets.from_graph(@graph_config)
                           .custom_sort(@spending_state.sort_column, @spending_state.sort_direction)
                           .page params[:page]
  end

  def new; end

  def show
    @basket = Basket.find(params[:id])
    return if @basket.user == current_user
    redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
  end

  def create
    BasketWorker.perform_async(current_user.id, params[:date], session[:access_token])
    # GoogleApi.process_api_request(current_user, params[:date], session[:access_token])
  end

  def disassociate_user
    current_user.disassociate_baskets
    redirect_to baskets_path, flash: { alert: 'Purchase history deleted from your account' }
  end
end
