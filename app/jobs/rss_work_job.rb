require 'robot'

class RssWorkJob < ApplicationJob
  queue_as :rss_job

  rescue_from(Robot::RSSProbe::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(Robot::RSSProbe::RetryTooManyTimeException) do |exp|
    record_failure(exp)
  end

  rescue_from(StandardError) do |exp|
    # StandardError 会捕获包括 RuntimeError 的异常
    record_failure(exp)
  end

  def record_failure(exp)
    probe_setting = self.arguments.first

    RssProbeHistory
        .find_or_create_by(probe_setting_id: probe_setting.id, jid: self.job_id)
        .update({status: 'fail', detail: exp.message + exp.backtrace.join})
  end

  def perform(setting)
    # 获取 RSS Feed
    rss_feeds = Robot::RSSProbe.new(
        setting.url,
        port: setting.port,
        proxy: setting.proxy,
        retry_limit: setting.retry_limit,
        log_path: setting.log_path
    ).fetch

    history = RssProbeHistory
                  .find_by(probe_setting_id: self.arguments.first.id, jid: self.job_id)

    # 保持 RSS 信息到数据库
    RssFeed.store_rss_to_db(setting, history.id, self.job_id, rss_feeds)
  end
end
