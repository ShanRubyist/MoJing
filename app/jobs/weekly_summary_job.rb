class WeeklySummaryJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SummaryMailer#.with(users: @users, rss_feeds: @rss_feeds, rss_sources: @rss_sources)
        .weekly_notify
        .deliver_later!
  end
end
