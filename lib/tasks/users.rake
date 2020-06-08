# frozen_string_literal: true

namespace :users do
  desc 'Update all users metadata'
  task update: :environment do
    User.unscoped.reorder(label: :asc).map do |u|
      puts(u.username || u.cf)
      u.save
    end
  end
end
