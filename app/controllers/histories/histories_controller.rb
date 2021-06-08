# frozen_string_literal: true

module Histories
  class HistoriesController < ::ApplicationController
    def rss_histories
      params[:page] = (params[:page].to_i < 1) ? 1 : params[:page]

      rst = RssProbeHistory
                .find_by_sql(<<-SQL
                  select rph.*, count(rf.id) as new_feeds_count, to_char(rph.created_at at time zone 'pst', 'yyyy-mm-dd hh24:mi:ss') as created_at_local_time
                  from rss_probe_histories as rph
                  left join probe_settings as ps
                  on ps.id = rph.probe_setting_id
                  left join rss_feeds as rf
                  on rph.id = rf.rss_probe_history_id
                  where ps.id = #{params[:setting_id]}
                  group by rph.id
                  order by rph.created_at desc
                  limit 10
                  offset #{ (params[:page].to_i - 1) * 10 }
            SQL
            )
      render json: rst.to_json
    end

    def goods_histories
      params[:page] = (params[:page].to_i < 1) ? 1 : params[:page]

      rst = GoodsRefreshHistory
                .find_by_sql(<<-SQL
                  select grh.*, to_char(grh.created_at at time zone 'pst', 'yyyy-mm-dd hh24:mi:ss') as created_at_local_time
                  from goods_refresh_histories as grh
                  where grh.pdd_web_spider_setting_id = #{params[:setting_id]}
                  order by grh.created_at desc
                  limit 10
                  offset #{ (params[:page].to_i - 1) * 10 }
            SQL
            )
      render json: rst.to_json
    end

    def histories
      if params[:type] == '0'
        rss_histories
      elsif params[:type] == '1'
        goods_histories
      else
        render json: []
      end
    end
  end
end