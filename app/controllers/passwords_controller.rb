class PasswordsController < ApplicationController
  skip_before_action :require_password_change
  def edit
    render 'edit'
  end

  def update
    if current_user.update_with_password(user_params)
      redirect_to baskets_path, flash: { notice: 'Password changed!' }
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:current_password, :password, :password_confirmation, :changed_password)
    end
end
