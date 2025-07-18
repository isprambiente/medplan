class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
  skip_before_action :verify_authenticity_token, only: :openid_connect

  def openid_connect
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    # @user = User.from_omniauth(request.env["omniauth.auth"])
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted? && @user.errors.empty?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "OpenIDConnect") if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end