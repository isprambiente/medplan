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

# after 'deploy:finishing',     'deploy:cleanup'
before 'deploy:log_revision', 'puma:stop'
before 'deploy:log_revision', 'puma:start'
