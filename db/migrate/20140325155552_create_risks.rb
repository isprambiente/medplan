# frozen_string_literal: true

# This migration manage risks table
class CreateRisks < ActiveRecord::Migration[4.2]
  def change
    create_table :risks do |t|
      t.string :code
      t.string :title, null: false, default: '', index: true
      t.boolean :printed, default: true, null: false

      t.timestamps
    end
  end
end
