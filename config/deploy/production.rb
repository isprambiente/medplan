# frozen_string_literal: true

server 'medplan.intranet.isprambiente.it', user: 'medplan', roles: %w[web app db]
set :deploy_to, '/home/medplan/production'
set :rails_env, 'production'
set :branch, 'master'
set :rvm_ruby_version, '3.1.2@medplan'

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! "config/settings/production.local.yml", "#{shared_path}/config/settings/production.yml"
      end
    end
  end
end