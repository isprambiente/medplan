# frozen_string_literal: true

# This migration add index into risks table
class AddUniqueIndexToRisk < ActiveRecord::Migration[6.0]
  def up
    remove_index :risks, :title
    add_index :risks, :title, unique: true, order: { title: :asc }
  end

  def down
    remove_index :risks, :title
    add_index :risks, :title, order: { title: :asc }
  end
end
