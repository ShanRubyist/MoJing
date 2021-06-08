class RssFeed < ApplicationRecord
  include RssSavable

  belongs_to :probe_setting

  belongs_to :rss_probe_history

  has_many :user_rss_feed_ships
  has_many :users, :through => :user_rss_feed_ships

  # default_scope -> { order('created_at desc') }
  scope :order_by_desc, -> { order('rss_feeds.created_at desc') }
end
