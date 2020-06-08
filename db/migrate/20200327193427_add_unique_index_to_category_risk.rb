# frozen_string_literal: true

# This migration add index into category_risks table
class AddUniqueIndexToCategoryRisk < ActiveRecord::Migration[6.0]
  def up
    add_index :category_risks, %i[category_id risk_id], unique: true, order: { category_id: :asc, risk_id: :asc }
  end

  def down
    remove_index :category_risks, %i[category_id risk_id]
  end
end
