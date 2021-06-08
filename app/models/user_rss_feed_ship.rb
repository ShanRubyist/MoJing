class UserRssFeedShip < ApplicationRecord
  belongs_to :user
  belongs_to :rss_feed

  validates :user_id, presence: true
  validates :rss_feed_id, presence: true
end
