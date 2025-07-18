# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'bootsnap', '>= 1.16.0', require: false
gem 'pg'
gem 'puma', '~> 6.0'
gem 'rails', '~> 8.0'
gem 'sass-embedded', '~> 1.85'
gem 'sprockets-rails'
gem 'tzinfo-data'
gem 'jbuilder'
gem 'fiddle'

# Use Redis for Action Cable
gem 'redis', '~> 4.0'
gem 'turbo-rails', '~> 1.0.0'
gem 'stimulus-rails'

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
  # gem 'capistrano3-puma',   require: false
  gem 'capistrano-yarn',    require: false
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'webdrivers'
end

gem 'active_storage_validations'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'config'
gem 'devise'
gem 'omniauth_openid_connect'
gem 'omniauth-rails_csrf_protection'
gem 'hamlit'
gem 'high_voltage' # pagine statiche
gem 'icalendar', require: false
gem 'pagy'
gem 'route_translator'
gem 'whenever', require: false

gem "image_processing", "~> 1.14"
gem 'dotenv-rails'
