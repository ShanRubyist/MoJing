module GoodsReadable
  extend ActiveSupport::Concern

  included do |base|
  end

  def goods_list(page = 1, per = 20)
    # goods = Good.includes(
    #     :shop => {
    #         :pdd_web_spider_setting => :user
    #     }
    # ).includes(
    #     :shop => :shops_extras,
    #     :shop => :dsrs,
    #     :shop => :platform,
    # ).includes(
    #     :goods_extras,
    #     :mall_services,
    #     :goods_comments,
    #     :coupons,
    #     :goods_images,
    #     :skus
    # ).includes(
    #     :skus => :skus_extras
    # ).where(:users => {:id => current_user.id}).page(page).per(per)

    goods = Good
                .includes(
                    :shop => {
                        :pdd_web_spider_setting => :user,
                    }
                )
                .includes(
                    :shop => {
                        :pdd_web_spider_setting => :goods_refresh_histories
                    }
                )
                .where(:users => {:id => current_user.id})
                .page(page)
                .per(per)

    goods_hash = {}

    goods.map do |good|
      good_hash = {}
      good_hash['mall_services'] = good.mall_services.last.try(:services)
      good_hash['coupons'] = good.coupons.last.try(:coupons)
      good_hash['goods_images'] = good.goods_images.last.try(:goods_images)

      good_hash['skus'] = {}
      good.skus.map do |sku|
        sku_hash = {}
        sku_hash['skuid'] = sku.skuid
        sku_hash['spec'] = sku.skus_extras.last.try :spec
        sku_hash['normal_price'] = sku.skus_extras.last.try :normal_price
        sku_hash['group_price'] = sku.skus_extras.last.try :group_price

        good_hash['skus'][sku.skuid] = sku_hash
      end

      good_hash['goods_comments'] = {}
      good_hash['goods_comments'] = good.goods_comments.map do |goods_comment|
        goods_comments_hash = {}
        goods_comments_hash['customer_name'] = goods_comment.customer_name
        goods_comments_hash['comment'] = goods_comment.comment
        goods_comments_hash['time'] = goods_comment.time.try(:localtime).try(:strftime, "%Y-%m-%d %H:%M")

        # good_hash['goods_comments'][goods_comment.customer_name + goods_comment.time.to_s] = goods_comments_hash
        [
            goods_comments_hash['customer_name'],
            goods_comments_hash['comment'],
            goods_comments_hash['time']
        ]
      end

      good_hash['name'] = good.goods_extras.last.try :name
      good_hash['spu_id'] = good.spu_id
      good_hash['sales_num'] = good.goods_extras.last.try :sales_num
      good_hash['comments_total_num'] = good.goods_extras.last.try :comments_total_num

      good_hash['vendor_id'] = good.shop.vendor_id
      good_hash['shop_name'] = good.shop.shop_name
      good_hash['shop_url'] = '//yangkeduo.com/' + good.shop.shop_url
      good_hash['shop_sales_num'] = good.shop.shops_extras.last.try :sales_num
      good_hash['goods_num'] = good.shop.shops_extras.last.try :goods_num
      good_hash['platform'] = good.shop.platform.name
      good_hash['logistics_score'] = good.shop.dsrs.last.try :logistics_score
      good_hash['desc_score'] = good.shop.dsrs.last.try :desc_score
      good_hash['service_score'] = good.shop.dsrs.last.try :service_score

      good_hash['status'] = good.shop.pdd_web_spider_setting.goods_refresh_histories.try(:last).try(:status)
      good_hash['detail'] = good.shop.pdd_web_spider_setting.goods_refresh_histories.try(:last).try(:detail)
      good_hash['setting_id'] = good.shop.pdd_web_spider_setting.id
      good_hash['jid'] = good.shop.pdd_web_spider_setting.goods_refresh_histories.try(:last).try(:jid)

      goods_hash[good.spu_id] = good_hash
    end
    goods_hash
  end

  def detail_change_history(data, compare, time = :created_at)
    prev = data.first
    period = data.first
    has_last = nil
    changed = nil

    period_list = data.map do |item|
      if item === Array
        current_indicator = item.send(compare.to_sym).sort
        prev_indicator = prev.send(compare.to_sym).sort
      else
        current_indicator = item.send(compare.to_sym)
        prev_indicator = prev.send(compare.to_sym)
      end

      changed = (current_indicator != prev_indicator)

      prev = item

      if changed || has_last.nil?
        has_last = item.send(time) - period.send(time)
        period = item
      end
    end.compact

    lastest_period_time = Time.now
    period_list.reverse.map do |item|
      changed_description = changed ? '有变动' : '暂无变动'

      rst = {
          compare.to_sym => (item === Array) ? item.send(compare.to_sym).sort : item.send(compare.to_sym),
          changed: changed_description,
          from_when: item.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
          has_last: human_how_long_after(lastest_period_time - item.created_at)
      }

      lastest_period_time = item.created_at
      rst
    end
  end

  private

  def human_how_long_after(sec)
    return unless sec

    if sec < 60 * 60
      "已持续 #{sec.to_i / 60} 分钟"
    elsif sec < 60 * 60 * 24
      "已持续 #{sec.to_i / (60 * 60)} 小时"
    elsif sec < 60 * 60 * 24 * 365
      "已持续 #{sec.to_i / (60 * 60 * 24)} 天"
    else
      "已持续 #{sec.to_i / (60 * 60 * 24 * 365)} 年"
    end
  end

  module ClassMethods
  end
end
