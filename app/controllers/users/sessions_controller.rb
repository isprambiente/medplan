# frozen_string_literal: true

# This controller handles the user login/logout and is used by Devise.
# It is empty because we are using the default behaviour of Devise, but it can be customized if needed.
class Users::SessionsController < Devise::OmniauthCallbacksController
  # You can override the default Devise behaviour here if needed.
  # For example, you can customize the login/logout process, or add additional actions.
  def new; end
end