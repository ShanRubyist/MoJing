class SummaryMailer < ApplicationMailer
  def weekly_notify
    @users = User.count
    @rss_feeds = RssFeed
                     .includes(:user_rss_feed_ships)
                     .where(:user_rss_feed_ships => {:unread => true})
                     .select(:link)
                     .distinct
                     .count

    @rss_sources = ProbeSetting.select(:url).distinct(true).count

    admin_email = ENV['ADMIN_EMAIL']
    mail(to: admin_email, from: ENV['EMAIL_FROM_ADDRESS'], subject: 'TianLuo Weekly Summary')
  end

  def monthly_notify
    @users = User.count
    @rss_feeds = RssFeed
                     .includes(:user_rss_feed_ships)
                     .where(:user_rss_feed_ships => {:unread => true})
                     .select(:link)
                     .distinct
                     .count

    @rss_sources = ProbeSetting.select(:url).distinct(true).count

    admin_email = ENV['ADMIN_EMAIL']
    mail(to: admin_email, subject: 'TianLuo Monthly Summary')
  end

end
