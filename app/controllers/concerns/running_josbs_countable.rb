require 'sidekiq/api'

module RunningJosbsCountable
  extend ActiveSupport::Concern

  included do |base|
  end

  def running_rss_jobs_count
    Sidekiq::Queue.new('rss_job').size
  end

  def running_goods_jobs_count
    Sidekiq::Queue.new('web_spider').size
  end

  module ClassMethods
  end
end
