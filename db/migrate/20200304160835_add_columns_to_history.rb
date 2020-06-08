# frozen_string_literal: true

# This migration add columns doctor and author into histories table
class AddColumnsToHistory < ActiveRecord::Migration[6.0]
  def up
    change_table :histories, bulk: true do |t|
      t.rename  :doctor, :doc
      t.rename  :author, :auth
      t.integer :doctor_id, index: true
      t.integer :author_id, index: true
    end
    add_foreign_key :histories, :users, column: :doctor_id, primary_key: 'id', on_delete: :restrict
    add_foreign_key :histories, :users, column: :author_id, primary_key: 'id', on_delete: :restrict

    History.all.each do |h|
      doc = User.unscoped.find_by(label: h.doc)
      auth = User.unscoped.find_by(label: h.auth)
      next unless doc && auth

      h.doctor = doc
      h.author = auth
      h.save(validate: false)
    end
  end

  def down
    change_table :histories, bulk: true do |t|
      t.remove :doctor_id
      t.remove :author_id
      t.rename :doc, :doctor
      t.rename :auth, :author
    end
  end
end
