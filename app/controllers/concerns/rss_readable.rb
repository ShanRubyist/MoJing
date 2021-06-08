module RssReadable
  extend ActiveSupport::Concern

  included do |base|
  end

  def rss_list(user_id = current_user.id, rss = nil, page = 1, per = 100)
    # FIXME: 需要展示已读未读状态、rss源标题
    rst = RssFeed
              .includes(:user_rss_feed_ships)
              .includes(:probe_setting)
              .includes(:probe_setting => :rss_info)
              .where(:user_rss_feed_ships => {:user_id => user_id})

    if rss
      rst = rst.where(:probe_settings => {:id => rss})
    end

    rst.order('user_rss_feed_ships.unread desc')
        .order_by_desc
        .page(page)
        .per(per)
  end

  module ClassMethods
  end
end
