class ShoppingListsController < ApplicationController
  # before_action :authenticate_user!

  def show
    @shopping_list = ShoppingList.find(params[:id])
    return unless my_user.id != @shopping_list.user.id
    redirect_to shopping_lists_path, flash: { alert: 'You can only view your own lists' }
  end

  def index
    @shopping_lists = my_user.shopping_lists
  end

  def create
    if current_user
      @shopping_list = current_user.shopping_lists.build(shopping_list_params)
      @shopping_list.save
      EmailWorker.perform_async(@shopping_list.id)
      render json: @shopping_list, status: 201
    else
      render json: { status: 403 }
    end
  end

  private

  def shopping_list_params
    params.require(:shopping_list).permit(
      items_attributes: %i[id name quantity price]
    )
  end
end
