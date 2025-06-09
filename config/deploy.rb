# frozen_string_literal: true

lock '~> 3.16'
set :application, 'medplan'
set :rvm_ruby_version, '3.4.4@medplan'
set :repo_url, 'https://github.com/isprambiente/medplan'
set :deploy_to, '/home/medplan'
# set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/master.key', 'config/credentials.yml.enc', '.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/sessions', 'tmp/state', 'vendor/bundle', 'public/system', 'config/settings', 'storage')

set :tmp_dir, '/home/medplan/shared/tmp'

set :keep_releases, 5

before "deploy:assets:precompile", "deploy:bun_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :bun_install do
    on roles(:web) do
      within release_path do
        # execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional --production")
        execute("cd #{release_path} && chmod 755 bin/yarn")
        execute("cd #{release_path} && chmod 755 bin/rails")
        execute("cd #{release_path} && chmod 755 bin/rake")
        execute("cd #{release_path} && chmod 755 bin/bundle")
      end
    end
  end
end

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! 'config/master.key', "#{shared_path}/config/master.key"
        upload! 'config/credentials.yml.enc', "#{shared_path}/config/credentials.yml.enc"
        upload! '.env.production.local', "#{shared_path}/.env"
      end
    end
  end
end
