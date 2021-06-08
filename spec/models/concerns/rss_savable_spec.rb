require 'rails_helper'

RSpec.describe RssSavable do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @probe_setting = FactoryBot.create(:probe_setting, users: [@user1, @user2])
    @rss_probe_history = FactoryBot.create(:rss_probe_history, probe_setting: @probe_setting)
    @rss_feeds = {
        title: 'title',
        description: '',
        last_build_date: '',
        link: 'link',
        items: [
            {
                title: 'rss title',
                description: '',
                author: '',
                pub_data: '',
                rss_probe_history_id: 1,
                link: 'rss link'
            }
        ]
    }
  end

  it '保存 rss feed' do
    @rss_feeds[:items] << {
        title: 'rss title2',
        description: '',
        author: '',
        pub_data: '',
        rss_probe_history_id: 1,
        link: 'rss link2'
    }

    allow(RssFeed).to receive(:transform).with(@rss_feeds).and_return(@rss_feeds)
    RssFeed.store_rss_to_db(@probe_setting, @rss_probe_history.id, 1, @rss_feeds)

    expect(RssFeed.count).to eq 2
  end

  it '不会重复保存相同 probe setting 和 link 的 rss feed' do
    @rss_feeds[:items] << @rss_feeds[:items].first.dup

    allow(RssFeed).to receive(:transform).with(@rss_feeds).and_return(@rss_feeds)
    RssFeed.store_rss_to_db(@probe_setting, @rss_probe_history.id, 1, @rss_feeds)

    expect(RssFeed.count).to eq 1
  end

  it '分发给有订阅此 rss 的全部用户' do
    allow(RssFeed).to receive(:transform).with(@rss_feeds).and_return(@rss_feeds)
    expect {
      RssFeed.store_rss_to_db(@probe_setting, @rss_probe_history.id, 1, @rss_feeds)
    }.not_to raise_error
    expect(UserRssFeedShip.count).to eq 2
  end
end
