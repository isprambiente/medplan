# frozen_string_literal: true

ENV.each { |k, v| env(k, v) }
set :output, "/home/medplan/#{ENV['RAILS_ENV']}/current/log/cron_log_#{ENV['RAILS_ENV']}_#{l(Time.zone.now, format: :file)}.log"

every 3.hours, roles: [:app] do
  runner 'UsersChecknewJob.perform_now'
end

# every 1.day, at: '0:01 am', roles: [:app] do
#   runner 'AutoDeleteProposedMeetingsJob.perform_now'
#end
