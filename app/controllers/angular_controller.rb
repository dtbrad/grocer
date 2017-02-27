class AngularController < ApplicationController
before_filter :auth_user

  def angular
    render 'angular'
  end

end
