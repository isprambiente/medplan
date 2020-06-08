# frozen_string_literal: true

# This migration add column position into users table
class AddColumnPositionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :position, :integer, index: true, null: false, default: 1
  end
end
