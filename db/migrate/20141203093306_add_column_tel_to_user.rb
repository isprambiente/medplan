# frozen_string_literal: true

# This migration add column tel into users table
class AddColumnTelToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :tel, :string, default: '', index: true
  end
end
