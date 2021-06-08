class ChangeColumnInProbeSettings < ActiveRecord::Migration[5.2]
  def change
    change_column :probe_settings, :user_id, :integer, null: true
    remove_index :probe_settings, :user_id
  end
end
