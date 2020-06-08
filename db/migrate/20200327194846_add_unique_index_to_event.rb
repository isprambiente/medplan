# frozen_string_literal: true

# This migration add index into events table
class AddUniqueIndexToEvent < ActiveRecord::Migration[6.0]
  def up
    add_index :events, %i[date_on city gender], unique: true, order: { date_on: :asc, city: :asc, gender: :asc }
  end

  def down
    remove_index :events, %i[date_on city gender]
  end
end
