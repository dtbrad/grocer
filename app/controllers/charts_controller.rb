class ChartsController < ApplicationController

  def most_spent
    @products = Product.all
  end

  def most_bought
    @products = Product.all
  end

  def product_monthly_purchasing
    @product = Product.find(params[:product_id])
  end

  def product_weekly_purchasing
    @product = Product.find(params[:product_id])
  end

  private

  def graph_form_params
    params.require(:graph_form).permit(:start_date, :end_date, :unit, :graph_change)
  end

end
