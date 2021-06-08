FactoryBot.define do
  factory :rss_feed1, class: RssFeed do
    association :probe_setting
    association :rss_probe_history
    title { 'rss feed' }
  end

  factory :rss_feed2, class: RssFeed do
    association :probe_setting
    association :rss_probe_history
    title { 'rss feed2' }
  end
end
