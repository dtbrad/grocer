class AngularController < ApplicationController
  def angular
    if !my_user
      redirect_to root_path, flash: { alert: 'Sample User needs to be loaded in database for listmaker to function' }
    else
      render 'angular'
    end
  end
end
