# frozen_string_literal: true

server 'test.yourserver.com', user: 'medplan', roles: %w[web app db]
set :deploy_to, '/home/medplan/staging'
set :rails_env, 'staging'
set :branch, 'staging'
set :rvm_ruby_version, '2.7.1@medplan'
