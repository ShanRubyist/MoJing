class CreateRssInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :rss_infos do |t|
      t.integer :probe_setting_id, null: false
      t.string :title, comment: 'RSS源标题'
      t.string :link, comment: 'RSS源网站链接'
      t.string :description, comment: 'RSS源描述'
      t.string :icon, comment: 'RSS源图标'

      t.timestamps
    end
    add_index :rss_infos, :probe_setting_id
  end
end
