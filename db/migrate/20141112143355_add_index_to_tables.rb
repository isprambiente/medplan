# frozen_string_literal: true

# This migration add index into audits table
class AddIndexToTables < ActiveRecord::Migration[4.2]
  def change
    # Audits
    # add_index :audits, :status
    # add_index :audits, :expire

    # Categories
    # add_index :categories, :title, unique: true
    # add_index :categories, :active

    # Events
    # add_index :events, :date_on

    # Histories
    # add_index :histories, :status
    # add_index :histories, :revision_date
    # add_index :histories, :city

    # Meetings
    # add_index :meetings, :status
    # add_index :meetings, :start_at

    # Risks
    # add_index :risks, :title, unique: true

    # Users
    # add_index :users, :username, unique: true
    # add_index :users, :city
    # add_index :users, :deleted
  end
end
