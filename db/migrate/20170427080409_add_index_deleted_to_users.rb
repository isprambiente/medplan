# frozen_string_literal: true

# This migration add index on deleted column into users table
class AddIndexDeletedToUsers < ActiveRecord::Migration[5.2]
  def change
    # add_index :users, :deleted, order: { deleted: :desc }
  end
end
