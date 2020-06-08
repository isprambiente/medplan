# frozen_string_literal: true

# This migration change type of column metadata from HSTORE to jsonb into users table
class ChangeColumnToUsers < ActiveRecord::Migration[5.2]
  def up
    change_table :users, bulk: true do |t|
      t.remove :metadata
      t.column :metadata, :jsonb, null: false, default: {}
      t.index  :metadata, using: :gin
    end
    execute 'DROP extension IF EXISTS hstore;'
  end

  def down
    execute 'CREATE extension IF NOT EXISTS hstore;'
    change_table :users, bulk: true do |t|
      t.remove_index :metadata
      t.remove :metadata
      t.column :metadata, :hstore
    end
  end
end
