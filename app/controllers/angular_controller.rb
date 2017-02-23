class AngularController < ApplicationController

  def angular
    if current_user
      render 'angular'
    else
      redirect_to root_path
    end
  end

end
