# frozen_string_literal: true

# This migration remove columns into histories table
class RemoveLogColumnFromHistory < ActiveRecord::Migration[6.0]
  def up
    change_table :histories, bulk: true do |t|
      t.remove :log
      t.remove :auth
      t.remove :doc
    end
  end

  def down
    change_table :histories, bulk: true do |t|
      t.column :log, :boolean, index: true, null: false, default: false
      t.column :auth, :string
      t.column :doc, :string
    end
  end
end
