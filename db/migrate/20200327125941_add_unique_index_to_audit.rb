# frozen_string_literal: true

# This migration add index into audits table
class AddUniqueIndexToAudit < ActiveRecord::Migration[6.0]
  def up
    add_index :audits, %i[category_id user_id status], unique: true, order: { user_id: :asc, category_id: :asc, status: :asc }
  end

  def down
    remove_index :audits, %i[category_id user_id status]
  end
end
