# frozen_string_literal: true

server 'test.yourserver.com', user: 'medplan', roles: %w[web app db]
set :deploy_to, '/home/medplan/staging'
set :rails_env, 'staging'
set :branch, 'staging'
set :rvm_ruby_version, '2.7.1@medplan'

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! "config/settings/staging.yml", "#{shared_path}/config/settings/staging.yml"
      end
    end
  end
end
