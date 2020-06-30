# frozen_string_literal: true

server Settings.deploy.host, user: 'medplan', roles: %w[web app db]
set :deploy_to, '/home/medplan/production'
set :rails_env, 'production'
set :branch, 'master'
set :rvm_ruby_version, '2.7.1@medplan'
