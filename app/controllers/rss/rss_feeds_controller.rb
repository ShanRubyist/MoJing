# frozen_string_literal: true
module Rss
  class RssFeedsController < ApplicationController
    include RssReadable

    def rss_list
      rst = super(current_user.id, params[:rss])

      return_json = []
      rst.each do |rss|
        return_json <<
    {
           title: rss.title,
           description: Loofah.fragment(rss.description).scrub!(:escape).to_html,
           pub_date: rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime("%Y-%m-%d %H:%M"),
           author: rss.author,
           link: rss.link,
           rss: rss.probe_setting.rss_info.title,
           rss_link: rss.probe_setting.rss_info.link,
           rss_description: rss.probe_setting.rss_info.description,
           icon: rss.probe_setting.rss_info.icon,
           status: !rss.user_rss_feed_ships.first.unread
       }
    end

      respond_to do |format|
        format.json { render json: return_json.to_json }
      end
    end

    def mark_readed
      rst = UserRssFeedShip.where(user_id: params[:user_id], unread: true)
                .update(unread: false)
      render json: {message: "marked #{rst.size} rss feeds"}
    end

    def unread_count
      rst = UserRssFeedShip.where(user_id: params[:id], unread: true).count
      render json: {unread_count: rst}
    end

    def load_more_rss_feed
      rss_list = rss_list(params['user_id'], params['page'], params['per'], params['rss'])

      rss_list_json = rss_list.map do |rss|
        {
            title: rss.title,
            description: rss.description.to_s,
            pub_date: rss.pub_date.nil? ? '' : rss.pub_date.localtime.strftime('%Y-%m-%d %H:%M'),
            author: rss.author,
            link: rss.link,
            rss: rss.rss_probe_history.title,
            rss_link: rss.rss_probe_history.link,
            rss_description: rss.rss_probe_history.description,
            status: rss.user_rss_feed_ships.first.unread
        }
      end

      render json: rss_list_json
    end
  end
end
