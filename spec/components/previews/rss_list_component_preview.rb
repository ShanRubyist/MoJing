class RssListComponentPreview < ViewComponent::Preview
  def rss_list_preview
    rss_list = RssFeed
                   .includes(:user_rss_feed_ships)
                   .where(:user_rss_feed_ships => {:user_id => 1})
                   .order('user_rss_feed_ships.unread desc')
                   .order_by_desc
                   .limit 10

    render(RssListComponent.new(rss_list: rss_list, current_user: User.first))
  end
end