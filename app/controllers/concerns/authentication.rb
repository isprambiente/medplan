# frozen_string_literal: true

# Namespace for administrative controllers and helpers.
#
# All controllers under this namespace are intended for site administrators
# and typically require elevated privileges. This namespace groups admin-only
# controllers, notifiers and helpers.
#
# @example
#   Authentication
module Authentication
  # Authentication concern for controllers.
  #
  # This module implements a lightweight session-based authentication layer used by
  # the application. It exposes helper methods used in controllers and views and
  # provides helpers for starting and terminating sessions.
  #
  # Provided methods:
  # * {#authenticated?}
  # * {#current_user}
  # * {#require_authentication}
  # * {#start_new_session_for}
  # * {#terminate_session}
  #
  # Usage:
  #   include Authentication
  #
  # @note This concern relies on a `Session` model and `Current.session` container.
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user, :impersonating?, :real_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def current_user
      impersonated_user || real_user
    end

    # Returns the currently logged-in user based on the session.
    # @return [User, nil] the User instance corresponding to session[:user_id], or nil if not found.
    def real_user
      @real_user ||= resume_session&.user
    end

    # Returns the user being impersonated, if any.
    # @return [User, nil] the User instance corresponding to session[:impersonated_user_id], or nil if not found.
    def impersonated_user
      return nil unless session[:impersonated_user_id]
      User.find_by(id: session[:impersonated_user_id])
    end

    # Starts impersonating another user by setting session[:impersonated_user_id].
    # @param user [User] the user to impersonate.
    def stop_impersonation
      session.delete(:impersonated_user_id)
    end

    # Checks if the current session is impersonating another user.
    # @return [Boolean] true if session[:impersonated_user_id] is present, false otherwise.
    def impersonating?
      session[:impersonated_user_id].present?
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end


    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path, alert: "Effettua il login per continuare."
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end


    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      session.delete(:impersonated_user_id)
      Current.session&.destroy
      Current.session = nil
      cookies.delete(:session_id)
    end
end
