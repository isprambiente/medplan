# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# This class have configuration for all tests
module ActiveSupport
  class TestCase
    include ActionDispatch::TestProcess
    include ActionDispatch::Assertions
    include FactoryBot::Syntax::Methods
    include Devise::Test::IntegrationHelpers

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end
