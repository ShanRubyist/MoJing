# Preview all emails at http://localhost:3000/rails/view_components/home_component/home
class HomeComponentPreview < ViewComponent::Preview
  def home
    rss_list = RssFeed
                   .includes(:user_rss_feed_ships)
                   .where(:user_rss_feed_ships => {:user_id => 1})
                   .order('user_rss_feed_ships.unread desc')
                   .order_by_desc
                   .limit 10
    
    # TODO: FIXME
    render HomeComponent.new do
      render RssListComponent.new(rss_list: rss_list, current_user: User.first)
      # render(GoodsListComponent.new(goods_list: @goods_list))
      # render(AddDiaglogComponent.new(current_user: User.first))
    end
  end
end