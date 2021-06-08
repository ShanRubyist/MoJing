class AddProbeSettingIdToRssFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :rss_feeds, :probe_setting_id, :integer#, null: false
    add_index :rss_feeds, :probe_setting_id
  end
end
