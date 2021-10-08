# frozen_string_literal: true

# This migration manage users table
class DeviseCreateUsers < ActiveRecord::Migration[4.2]
  def up
    execute <<-SQL
      CREATE extension IF NOT EXISTS hstore;
    SQL
    create_table(:users) do |t|
      ## Database authenticatable
      # t.string :email,              null: false, default: ""
      # t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Login field
      t.string :username, null: false, default: '', index: true, unique: true

      ## other
      t.string :label, default: ''
      t.hstore :metadata
      t.integer :city, index: true, null: false
      t.text :body, default: ''

      ## security groups
      t.boolean :secretary, default: false
      t.boolean :doctor, default: false
      t.boolean :admin, default: false

      t.timestamps
    end

    # add_index :users, :email,                unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end

  def down
    drop_table(:users)
    execute <<-SQL
      DROP extension IF EXISTS hstore;
    SQL
  end
end
