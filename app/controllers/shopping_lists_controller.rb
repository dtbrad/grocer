class ShoppingListsController < ApplicationController
  # before_action :authenticate_user!

  def index
    if current_user
      @shopping_lists = current_user.shopping_lists
      render json: @shopping_lists
    end
  end

  def show
    render json: ShoppingList.find(params[:id])
  end

  def create
    @shopping_list = current_user.shopping_lists.build(shopping_list_params)
    if @shopping_list.save
      if current_user.email != "sampleuser@mail.com"
        ListMailer.list_mailer(@shopping_list).deliver
      end
      render json: @shopping_list, status: 201
    else
      @shopping_lists = ShoppingList.all
      render :index
    end
  end

  private

  def shopping_list_params
    params.require(:shopping_list).permit(
       items_attributes: [:id, :name, :quantity, :price]
    )
  end

end
