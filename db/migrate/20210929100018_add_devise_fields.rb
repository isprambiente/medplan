# frozen_string_literal: true

# This migration add devise columns into users table
class AddDeviseFields < ActiveRecord::Migration[6.1]
  def up
    change_table :users, bulk: true do |t|
      t.string   :encrypted_password, null: false, default: ""
      t.string   :reset_password_token, index: true, unique: true
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.datetime :reset_password_sent_at
      t.boolean  :system, null: false, default: false, index: true
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :system
    end
  end
end
