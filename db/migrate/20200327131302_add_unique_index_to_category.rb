# frozen_string_literal: true

# This migration add index into categories table
class AddUniqueIndexToCategory < ActiveRecord::Migration[6.0]
  def up
    remove_index :categories, :title
    add_index :categories, :title, unique: true, order: { title: :asc }
  end

  def down
    remove_index :categories, :title
    add_index :categories, :title, order: { title: :asc }
  end
end
