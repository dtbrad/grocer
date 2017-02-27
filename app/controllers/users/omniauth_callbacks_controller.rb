class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user && @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) #Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, flash: { alert: 'There is no account associated with your gmail address. Please register a new account.' }
      end
  end
end
