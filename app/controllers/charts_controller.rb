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
end
