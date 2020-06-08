# frozen_string_literal: true

# This migration add column sended_at into meetings table
class AddColumnSendedAtToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :sended_at, :datetime, index: true
  end
end
