# frozen_string_literal: true

# This migration manage meetings table
class CreateMeetings < ActiveRecord::Migration[4.2]
  def change
    create_table :meetings do |t|
      t.references :audit, index: true
      t.references :event, index: true
      t.integer :status, index: true, null: false, default: 1
      t.time :start_at, null: false, index: true
      t.time :stop_at, null: false
      t.text :body

      t.timestamps
    end
  end
end
