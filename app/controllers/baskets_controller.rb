class BasketsController < ApplicationController
  helper_method :unit, :start_date, :end_date, :revised_start, :revised_end, :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    if current_user
      respond_to do |format|
        format.html {
          @graph_form = GraphForm.new({start_date: Time.now - 6.months, end_date: Time.now, unit: "months"})
          @unpaginated_unsorted_baskets = current_user.baskets.from_graph(start_date, end_date, unit)
          @baskets = @unpaginated_unsorted_baskets.custom_sort(sort_column, sort_direction)
          .page params[:page]
        }
        format.js {
          if params[:graph_change] == "yes"
            @graph_form = GraphForm.new(params[:graph_form])
          else
            @graph_form = GraphForm.new({start_date: revised_start.to_s, end_date: revised_end.to_s, unit: unit})
          end
          @unpaginated_unsorted_baskets = current_user.baskets.from_graph(@graph_form.start_date, @graph_form.end_date, @graph_form.unit)
          @baskets = @unpaginated_unsorted_baskets.custom_sort(sort_column, sort_direction)
          .page params[:page]
        }
      end
    end
  end

  def new
  end

  def show
    @basket = Basket.find(params[:id])
    if @basket.user != current_user
      redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
    end
  end

  def create
    BasketWorker.perform_async(current_user.id, params[:date], session[:access_token], params[:orig_email])
    # Scraper.process_emails(current_user, params[:date], session[:access_token], params[:orig_email])
  end

  def disassociate_user
    current_user.baskets.disassociate_user
    redirect_to baskets_path, flash: { alert: 'Purchase history deleted from your account' }
  end

  private

  def graph_form_params
    params.require(:graph_form).permit(:start_date, :end_date, :unit, :graph_change)
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end


  def unit
    params[:unit] ? params[:unit] : "months"
  end
  #
  # def duration
  #   params[:duration] ? params[:duration] : 12
  # end

  def start_date
    params[:start_date] ? params[:start_date] : Time.zone.now - 6.months
  end

  def revised_start
    params[:graph_form] ? params[:graph_form][:start_date] : start_date
  end

  def end_date
    params[:end_date] ? params[:end_date] : Time.zone.now
  end

  def revised_end
    params[:graph_form] ? params[:graph_form][:end_date] : end_date
  end

end
