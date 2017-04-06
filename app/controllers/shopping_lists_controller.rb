class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list = ShoppingList.find(params[:id])
    if current_user.id != @shopping_list.user.id
      redirect_to shopping_lists_path, flash: { alert: 'You can only view your own lists' }
    end
  end

  def index
    @shopping_lists = current_user.shopping_lists
  end

  def create
    @shopping_list = current_user.shopping_lists.build(shopping_list_params)
    if current_user.email != "sampleuser@mail.com"
      @shopping_list.save
      EmailWorker.perform_async(@shopping_list.id)
    end
    render json: @shopping_list, status: 201
  end

  private

  def shopping_list_params
    params.require(:shopping_list).permit(
       items_attributes: [:id, :name, :quantity, :price]
    )
  end

end
