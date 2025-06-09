# frozen_string_literal: true

server 'medplan.intranet.isprambiente.it', user: 'medplan', roles: %w[web app db]
set :deploy_to, '/home/medplan/production'
set :rails_env, 'production'
set :branch, 'master'

set :default_env, {
  'RAILS_OIDC_ISSUER':      ENV.fetch("RAILS_OIDC_ISSUER") { "https://my_issuer.com" },
  'RAILS_OIDC_USERNAME':    ENV.fetch("RAILS_OIDC_USERNAME") { "uid" },
  'RAILS_PORT':             ENV.fetch("RAILS_PORT") { "443" }.to_i,
  'RAILS_PROTOCOL':           ENV.fetch("RAILS_PROTOCOL") { "https" },
  'RAILS_HOST':             ENV.fetch("RAILS_HOST") { "localhost" },
  'RAILS_OIDC_IDENTIFIER':  ENV.fetch("RAILS_OIDC_IDENTIFIER") { "medplan" },
  'RAILS_OIDC_SECRET':      ENV.fetch("RAILS_OIDC_SECRET") { "secret" },
  'RAILS_SCHEME':           "#{ENV.fetch("RAILS_PROTOCOL") { "https" }}://#{ENV.fetch("RAILS_HOST") { "localhost" }}#{ENV.fetch("RAILS_PORT") {""}}/users/auth/openid_connect/callback"
}

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! "config/settings/production.local.yml", "#{shared_path}/config/settings/production.yml"
      end
    end
  end
end