# frozen_string_literal: true

every 3.hours, roles: [:app] do
  runner 'UsersChecknewJob.perform_now'
end
