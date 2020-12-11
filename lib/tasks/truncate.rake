# frozen_string_literal: true

# This rake truncate all data into tables
namespace :db do
  desc 'Truncate all tables'
  task truncate: :environment do
    conn = ActiveRecord::Base.connection
    tables = conn.tables
    tables.delete 'schema_migrations'
    tables.each { |table| conn.execute("TRUNCATE #{table}  RESTART IDENTITY CASCADE;") }
  end
end
