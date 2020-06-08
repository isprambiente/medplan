# frozen_string_literal: true

# This migration remove default configuration from username column into users table
class RemoveNotnullUsernameToUsers < ActiveRecord::Migration[4.2]
  def up
    change_column_null(:users, :username, null: true)
    change_column_default(:users, :username, nil)
  end

  def down
    change_column_null(:users, :username, null: false)
    change_column_default(:users, :username, '')
  end
end
