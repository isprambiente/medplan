# frozen_string_literal: true

# This migration manage histories table
class CreateHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :histories do |t|
      t.references :audit, index: true
      t.string :author, null: false, default: ''
      t.string :status, null: false, default: '', index: true
      t.string :doctor
      t.date :revision_date, index: true
      t.text :body
      t.string :lab
      t.integer :city, index: true

      t.timestamps
    end
  end
end
