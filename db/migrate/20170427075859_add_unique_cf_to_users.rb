# frozen_string_literal: true

# This migration add column unique cf costraint into users table
class AddUniqueCfToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :cf, unique: true, order: { cf: :asc }
  end
end
