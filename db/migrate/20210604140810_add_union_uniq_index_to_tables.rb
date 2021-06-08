class AddUnionUniqIndexToTables < ActiveRecord::Migration[5.2]
  def change
    add_index :user_rss_ships, [:user_id, :probe_setting_id], unique: true
    add_index :user_rss_feed_ships, [:user_id, :rss_feed_id], unique: true
    add_index :rss_feeds, [:probe_setting_id, :link]#, unique: true
  end
end
