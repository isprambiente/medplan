# frozen_string_literal: true

# This class is the father notifier class anc contains all shared config and methods
# Defaul sender are loaded from config/settings.yml - email
class ApplicationMailer < ActionMailer::Base
  default from: Settings.email.to_s
  layout 'mailer'
end
