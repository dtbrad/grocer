class ChartsController < ApplicationController

  def basket_spending
    @graph_form = GraphForm.new(graph_form_params)
    if @graph_form.valid?
      @start_date = @graph_form.start_date.to_s
      @end_date = @graph_form.end_date.to_s
      @unit = @graph_form.unit
      # binding.pry
      render  'basket_spending'
    end
  end

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
