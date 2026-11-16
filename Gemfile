# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "bootsnap", ">= 1.26.1", require: false
gem "pg"
gem "puma", "~> 8.1.1"
gem "rails", "~> 8.1.4.1"
gem "sass-embedded", "~> 1.108.2"
gem "sprockets-rails"
gem "tzinfo-data"
gem "jbuilder"
gem "fiddle"
gem "json"

# Use Redis for Action Cable
gem "redis", "~> 6.0.0"
gem "turbo-rails", "~> 2.0.23"
gem "stimulus-rails"

group :development, :test do
  gem "byebug", platforms: :windows
  gem "factory_bot_rails"
end

group :development do
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rails-omakase", require: false
  gem "yard"

  gem "better_errors"
  gem "letter_opener"
  gem "web-console"

  gem "capistrano",         require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rails",   require: false
  gem "capistrano-rvm",     require: false
  # gem 'capistrano3-puma',   require: false
  gem "capistrano-yarn",    require: false

  gem "traceroute"
  gem "ed25519"
  gem "bcrypt_pbkdf"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver", "~> 4.52.0"
  gem "database_cleaner"
  gem "shoulda", "~> 4.0.0"
  gem "shoulda-matchers", "~> 4.0.1"
  gem "webdrivers"
end

gem "active_storage_validations"
gem "caxlsx"
gem "caxlsx_rails"
gem "config"
gem "omniauth_openid_connect"
gem "omniauth-rails_csrf_protection"
gem "hamlit"
gem "high_voltage" # pagine statiche
gem "icalendar", require: false
gem "pagy"
gem "route_translator"
gem "whenever", require: false

gem "image_processing", "~> 2.2.0"
gem "dotenv-rails"

gem "bcrypt", "~> 3.1.22"
