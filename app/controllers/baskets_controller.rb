class BasketsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :my_user, only: %i[index show]

  def index
    @spending_state = SpendingState.new(params)
    @graph_config = @spending_state.set_graph
    return unless @my_user
    @baskets = @my_user.baskets.from_graph(@graph_config)
                       .custom_sort(@spending_state.sort_column, @spending_state.sort_direction)
                       .page params[:page]
  end

  def show
    @basket = Basket.find(params[:id])
    return if @basket.user == @my_user
    redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
  end

  def destroy_all
    current_user.baskets.destroy_all
    redirect_to baskets_path, flash: { alert: 'Your purchase history has been removed' }
  end
end
