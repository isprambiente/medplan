# frozen_string_literal: true

lock '3.14.1'
set :application, 'medplan'
set :repo_url, 'https://github.com/isprambiente/medplan'
set :deploy_to, '/home/medplan'
# set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/master.key', 'config/credentials.yml.enc')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/sessions', 'tmp/state', 'vendor/bundle', 'public/system', 'config/settings', 'storage')

set :tmp_dir, '/home/medplan/shared/tmp'

set :keep_releases, 5

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! 'config/master.key', "#{shared_path}/config/master.key"
        upload! 'config/credentials.yml.enc', "#{shared_path}/config/credentials.yml.enc"
      end
    end
  end
end
