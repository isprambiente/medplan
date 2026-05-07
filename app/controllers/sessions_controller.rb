# frozen_string_literal: true

#
# Controller responsible for managing user sessions, including login and logout actions.
#
# It handles authentication via OmniAuth and manages session lifecycle.
# It also includes rate limiting for login attempts to enhance security.
# @see ApplicationController
class SessionsController < ApplicationController
  # include Authentication

  allow_unauthenticated_access only: %i[ new create failure]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  # GET /login
  # Renders the login page where users can initiate the authentication process
  # @return [void] Renders the login view
  def new
  end

  # POST /login
  # Handles the authentication process using OmniAuth
  # If authentication is successful, starts a new session for the user
  # If authentication fails, redirects to the login page with an error message
  # @return [void] Redirects to the home page on success or back to login on failure
  def create
    auth = request.env["omniauth.auth"]
    unless auth && auth.uid
      redirect_to(new_session_path, alert: "Dati di autenticazione mancanti.") and return
      return
    end
    user = User.from_omniauth(request.env["omniauth.auth"])

    start_new_session_for(user)
    redirect_to after_authentication_url, success: "Benvenuto, #{user.label}!"
  end

  # DELETE /logout
  # Logs out the user by terminating the session
  # @return [void] Redirects to the home page with a logout success message
  def destroy
    terminate_session
    session[:user_id] = nil
    redirect_to(root_path, success: "Logout effettuato con successo.") and return
  end

  # GET /logout
  # Logs out the user by calling the destroy action
  def logout
    destroy
  end

  # OmniAuth failure callback
  # This action is called when OmniAuth authentication fails
  # It redirects to the login page with an error message
  # @return [void] Redirects to the login page with an error message
  def failure
    redirect_to(new_session_path, alert: "Autenticazione fallita: #{params[:message]}") and return
  end
end
