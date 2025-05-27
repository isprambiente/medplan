class AddColumnActiveToRisk < ActiveRecord::Migration[7.2]
  def change
    add_column :risks, :active, :boolean, null: false, default: true
    add_index :risks, :active
  end
end
