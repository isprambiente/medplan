# frozen_string_literal: true

# This migration add column into users table
class AddDeletedToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :deleted, :boolean, default: false, index: true
  end
end
