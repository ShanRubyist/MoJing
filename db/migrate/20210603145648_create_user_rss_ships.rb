class CreateUserRssShips < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rss_ships do |t|
      t.integer :user_id, null: false
      t.integer :probe_setting_id, null: false

      t.timestamps
    end

    add_index :user_rss_ships, :user_id
    add_index :user_rss_ships, :probe_setting_id

    # rename_table :probe_settings, :rss
  end
end
