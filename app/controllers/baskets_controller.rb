class BasketsController < ApplicationController
  helper_method :sort_column, :sort_direction
  # before_action :authenticate_user!
  before_filter :auth_user

  def index
    if current_user
      @baskets = current_user.baskets.custom_sort(sort_column, sort_direction)
      .page params[:page]
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def new
    if !current_user.oauth_token
      redirect_to baskets_path, flash: { alert: 'To import your emails, log out and then sign in again through gmail.' }
    end
  end

  def show
    @basket = Basket.find(params[:id])
    if @basket.user != current_user
      redirect_to baskets_path, flash: { alert: 'You can only view your own baskets' }
    end
  end

  def create
    if !current_user.oauth_token || (Time.now.utc >= current_user.oauth_expires_at)
      redirect_to new_user_session_path, flash: { alert: 'You must sign into this app through gmail.' }
    else
    # if Scraper.grab_emails(current_user, params[:date]).length > 0
      # BasketWorker.perform_async(current_user.id, params[:date])
     if Scraper.process_emails(current_user, params[:date])
      redirect_to baskets_path, flash: { notice: 'Purchase History Loaded. Your numbers are now updating in the background.' }
    else
      redirect_to baskets_path, flash: { alert: 'You have no receipts in your inbox for the date-range you provided' }
    end
  end
  end

  def remove
    current_user.baskets.destroy_all
    redirect_to baskets_path, flash: { alert: 'Purchase History Deleted' }
  end

  private

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

end
