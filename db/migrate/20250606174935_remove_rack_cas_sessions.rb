class RemoveRackCasSessions < ActiveRecord::Migration[8.0]
  def up
    drop_table :sessions
  end

  def down
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.string :cas_ticket
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :cas_ticket
    add_index :sessions, :updated_at
  end
end
