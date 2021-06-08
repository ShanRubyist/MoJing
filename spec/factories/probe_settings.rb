FactoryBot.define do
  factory :probe_setting do
    url { 'https://ruby-china.org/topics/feed'}
    port { 80 }
    retry_limit { 3 }
    proxy {}
    log_path {}
    status { true }
  end

  factory :invalid_probe_setting, class: ProbeSetting do
    url { nil }
    port { 80 }
    retry_limit { 3 }
    proxy {}
    log_path {}
    status { true }
  end
end