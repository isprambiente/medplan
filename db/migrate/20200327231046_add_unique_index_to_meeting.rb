# frozen_string_literal: true

# This migration add index into meetings table
class AddUniqueIndexToMeeting < ActiveRecord::Migration[6.0]
  def up
    add_index :meetings, %i[event_id audit_id], unique: true
  end

  def down
    remove_index :meetings, %i[event_id audit_id]
  end
end
