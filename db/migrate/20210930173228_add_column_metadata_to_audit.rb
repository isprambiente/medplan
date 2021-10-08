class AddColumnMetadataToAudit < ActiveRecord::Migration[6.1]
  def change
    change_table :audits, bulk: true do |t|
      t.column :metadata, :jsonb, null: false, default: {}
      t.index  :metadata, using: :gin
    end
  end
end
