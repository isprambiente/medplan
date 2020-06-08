# frozen_string_literal: true

# This migration manage categories table
class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.string :code
      t.string :title, null: false, default: '', index: true
      t.integer :months, null: false, default: 0
      t.text :protocol
      t.boolean :active, index: true, default: true, null: false

      t.timestamps
    end
  end
end
