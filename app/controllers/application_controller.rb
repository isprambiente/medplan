# frozen_string_literal: true

# This conroller contain the methods shared for all sons
# * layout :set_layout -> set the view layout with {set_layout} method
# * before_action :authenticate_user! -> before every action execute
#   devise.authenticate_user! method. This method check if the user
#   is signed in or require authentication
# * before_action :set_locale
# @raise [ActiveRecord::RecordNotFound] if a query can't be resolved
#  execute {record_not_found!}
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  layout :set_layout
  before_action :authenticate_user!
  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound do
    record_not_found!
  end

  rescue_from ActiveRecord::DeleteRestrictionError do
    destroy_restricted!
  end

  # Check if controller is Devise
  # @return [Bool]
  def do_not_check_authorization?
    respond_to?(:devise_controller?) # || respond_to?(:pages_controller?)
  end

  # Execute {access_denied!} unless current_user.secretary == TRUE
  # @return [nil]
  def secretary_in!
    access_denied! unless current_user.secretary?
  end

  # Execute {access_denied!} unless current_user.doctor == TRUE
  # @return [nil]
  def doctor_in!
    access_denied! unless current_user.doctor?
  end

  # Execute {access_denied!} unless current_user.doctor == true
  # or current_user.secretary == true
  # @return [nil]
  def powered_in!
    access_denied! unless current_user.doctor? || current_user.secretary?
  end

  # Execute #access_denied unless current_user.admin == true
  # @return [nil]
  def admin_in!
    access_denied! unless current_user.admin?
  end

  def translate_errors(errors = [], scope: '')
    translated = []
    errors.each do |e|
      translated << "#{t(e.attribute, scope: scope, default: e.attribute)} #{e.message}"
    end
    return translated
  end

  private

  # Create callback with class error messages
  # @param [Class] obj
  # @param [Text] scope
  # @return [String] errors localized messages
  def write_errors(obj, scope: false)
    obj.errors.map { |e| "#{t_field(e.attribute, scope || obj.class.table_name.singularize)} #{e.message}" }.join(', ')
  end

  # Set locale from `params[:locale]`.
  # If params[:locale] is unset or is not available,
  # the method set the default locale
  # @return [Symbol,String] new locale definition
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Render 404 page and stop the work
  # @return [nil]
  def record_not_found!
    render partial: 'errors/404', status: 404 && return
  end

  # Select the layout name based on request type: xhr request or other
  # @return [String] the layout name
  def set_layout
    request.xhr? ? 'empty' : 'application'
  end

  # Render 401 page and stop the work
  # @return [nil]
  def access_denied!
    render partial: 'errors/401', status: 401 && return
  end

  # {access_denied!} unless the request.xhr == true
  # @return [nil]
  def xhr_required!
    access_denied! unless request.xhr?
  end

  # Render message and stop the work
  # @return [nil]
  def destroy_restricted!
    flash.now[:error] = "Non è possibile cancellare questo record poichè è collegato ad altre informazioni!"
    respond_to do |format|
      format.html { render partial: 'errors/401', status: 401 && return }
      format.turbo_stream {
        render turbo_stream: [ turbo_stream.replace(:flashes, partial: "flashes") ]
      }
    end
  end

  # Localize a fieldName if #obj is present
  # @param [Text] field_label
  # @param [Text] obj
  # @return [String] localized
  def t_field(field_label = nil, obj = '')
    return '' if field_label.blank?

    case obj
    when Class
      I18n.t(field_label, scope: "activerecord.attributes.#{obj.class}", default: field_label).try(:capitalize)
    when String
      I18n.t(field_label, scope: "activerecord.attributes.#{obj}", default: field_label).try(:capitalize)
    else
      I18n.t(field_label, default: field_label).try(:capitalize)
    end
  end
end
