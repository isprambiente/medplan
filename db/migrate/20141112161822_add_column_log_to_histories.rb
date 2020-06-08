# frozen_string_literal: true

# This migration add column log into histories table
class AddColumnLogToHistories < ActiveRecord::Migration[4.2]
  def change
    add_column :histories, :log, :boolean, null: false, default: false, index: true
    add_index :histories, :log
  end
end
