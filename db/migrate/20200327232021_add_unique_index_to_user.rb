# frozen_string_literal: true

# This migration add index into users table
class AddUniqueIndexToUser < ActiveRecord::Migration[6.0]
  def up
    remove_index :users, :username
    add_index :users, :username, unique: true, order: { username: :asc }
  end

  def down
    remove_index :users, :username
    add_index :users, :username, order: { username: :asc }
  end
end
