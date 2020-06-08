# frozen_string_literal: true

# This migration change column name of position to postazione into users table
class ChangeColumnNameToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :position, :postazione
  end
end
