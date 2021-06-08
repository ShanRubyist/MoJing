# frozen_string_literal: true
module Rss
  class RssController < ApplicationController
    include RunningJosbsCountable
    include ApplicationHelper

# for mobile
    def index
      @running_rss_jobs_count = running_rss_jobs_count
      # @running_goods_jobs_count = running_goods_jobs_count

      per ||= 200
      params['page'] ||= 1

      @all_rss_list = ProbeSetting.find_by_sql(<<-SQL
      select histories.status as refresh_status, *
      from probe_settings as ps
      left join (
            select probe_setting_id, jid, status, detail, last_build_date
            from rss_probe_histories
            where (probe_setting_id, created_at) in (
              select probe_setting_id, max(created_at) as latest
              from rss_probe_histories
              group by probe_setting_id
            )
      ) as histories
      on histories.probe_setting_id = ps.id
      where user_id = #{current_user.id}
      order by ps.created_at desc
      limit #{per}
      offset #{ (params['page'] - 1) * per }
      SQL
      )

      @all_rss_list_json = []

      @all_rss_list.each do |rss|
        @all_rss_list_json << {
            probe_settings_id: rss.id,
            rss: rss.url,
            port: rss.port,
            proxy: rss.proxy,
            retry_limit: rss.retry_limit,
            latest_updated: rss.last_build_date,
            status: rss.refresh_status,
            jid: rss.jid,
            detail: rss.detail
        }
      end
      # @all_good_list = PddWebSpiderSetting.where(user: current_user).all
      render template: 'rss/rss/mobile/index'
    end
  end
end
