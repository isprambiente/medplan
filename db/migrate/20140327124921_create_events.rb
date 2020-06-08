# frozen_string_literal: true

# This migration manage events table
class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.date :date_on, null: false, index: true
      t.integer :gender, null: false
      t.text :body
      t.string :city, null: false
      t.integer :max_users, default: 10, null: false

      t.timestamps
    end
  end
end
