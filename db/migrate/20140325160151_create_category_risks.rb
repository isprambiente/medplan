# frozen_string_literal: true

# This migration manage category_risks table
class CreateCategoryRisks < ActiveRecord::Migration[4.2]
  def up
    create_table :category_risks do |t|
      t.references :category, index: true, null: false
      t.references :risk, index: true, null: false
      t.timestamps
    end
  end

  def down
    drop_table :category_risks
  end
end
