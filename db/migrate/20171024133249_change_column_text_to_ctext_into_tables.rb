# frozen_string_literal: true

# This migration change type of column label from string to citext into users table
class ChangeColumnTextToCtextIntoTables < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    change_column :users, :label, :citext
  end
end
