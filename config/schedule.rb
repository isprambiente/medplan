# frozen_string_literal: true

ENV.each { |k, v| env(k, v) }
set :output, "/home/medplan/#{ENV['RAILS_ENV']}/current/log/cron_log_#{ENV['RAILS_ENV']}.log"

every 3.hours, roles: [:app] do
  runner 'UsersChecknewJob.perform_now'
end
