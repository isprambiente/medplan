# frozen_string_literal: true

# This migration add cf column into users table
class AddCfToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :cf, :string, index: true, unique: true, null: false, default: ''
  end
end
