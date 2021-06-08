FactoryBot.define do
  factory :rss_info do
    association :probe_setting
    title { 'rss title test' }
  end
end
