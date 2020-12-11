# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'pg'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.0'
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5.0'
gem 'webpacker', '~> 5.0'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw]

gem 'nokogiri', '~> 1.11.rc1', platforms: :ruby

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'yard'

  gem 'better_errors'
  gem 'letter_opener'
  gem 'web-console'

  gem 'capistrano',         require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano3-puma',   require: false
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'database_cleaner'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'webdrivers'
end

gem 'active_storage_validations'
gem 'caxlsx_rails'
gem 'config'
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'hamlit'
gem 'high_voltage' # pagine statiche
gem 'icalendar', require: false
gem 'pagy'
gem 'route_translator'
gem 'whenever', require: false
