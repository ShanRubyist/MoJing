require 'rails_helper'

RSpec.describe 'RssFeedsController', type: :routing do
  describe 'routing' do
    it 'routes to #unread_count' do
      expect(get: "/rss_feeds/unread_count").to route_to("rss/rss_feeds#unread_count")
    end

    it 'routes to #mark_readed' do
      expect(put: "/rss_feeds/mark_readed").to route_to("rss/rss_feeds#mark_readed")
    end

    it 'routes to #load_more_rss_feed' do
      expect(get: "/rss_feeds/load_more_rss_feed").to route_to("rss/rss_feeds#load_more_rss_feed")
    end
  end

  describe 'routes with format' do
    it 'routes to #unread_count' do
      expect(get: "/rss_feeds/unread_count.json").to route_to("rss/rss_feeds#unread_count", { format: 'json'})
    end

    it 'routes to #mark_readed' do
      expect(put: "/rss_feeds/mark_readed.json").to route_to("rss/rss_feeds#mark_readed", { format: 'json'})
    end

    it 'routes to #load_more_rss_feed' do
      expect(get: "/rss_feeds/load_more_rss_feed.json").to route_to("rss/rss_feeds#load_more_rss_feed", { format: 'json'})
    end
  end
end