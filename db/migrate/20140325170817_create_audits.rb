# frozen_string_literal: true

# This migration manage audits table
class CreateAudits < ActiveRecord::Migration[4.2]
  def change
    create_table :audits do |t|
      t.references :user, index: true, null: false
      t.references :category, index: true, null: false
      t.integer :status, null: false, default: 1, index: true
      t.date :expire, null: false, index: true

      t.timestamps
    end
  end
end
