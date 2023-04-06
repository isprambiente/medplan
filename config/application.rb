# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'rack-cas/session_store/active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# This module contain the configurations for all app
module MedPlan
  # This class contain the configurations for all app
  class Application < Rails::Application
    config.load_defaults 7.0
    config.rack_cas.session_store = RackCAS::ActiveRecordStore
    config.rack_cas.server_url = ENV['RAILS_CAS_URL'] || Settings.auth.cas
    config.rack_cas.service = '/users/service' # If your user model isn't called User, change this
    config.encoding = 'utf-8'
    config.i18n.default_locale = :it
    config.i18n.available_locales = [:it]
    config.i18n.enforce_available_locales = true
    config.i18n.fallbacks = true
    config.time_zone = 'Rome'
    config.generators do |g|
      g.template_engine :haml
    end
  end
end
