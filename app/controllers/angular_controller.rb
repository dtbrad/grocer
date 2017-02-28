class AngularController < ApplicationController
before_action :authenticate_user!

  def angular
    render 'angular'
  end

end
