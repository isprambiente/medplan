require_relative "boot"

require "rails/all"
require 'rack-cas/session_store/active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MedPlan
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
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
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))
  end
end
