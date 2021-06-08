# frozen_string_literal: true

require 'json'

module GoodsSavable
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def store_goods_to_db(pdd_web_spider_setting, raw_data)
      data = transform_data(raw_data)
      shop = Shop.create_with(shop_name: data[:shop][:name],
                              shop_url: data[:shop][:shop_url],
                              platform: Platform.find_by_name('拼多多'),
                              vendor_id: data[:shop][:id])
                 .find_or_create_by(pdd_web_spider_setting: pdd_web_spider_setting)

      shop.shops_extras.create(shop_id: shop.id,
                               sales_num: data[:shop][:sales_num],
                               goods_num: data[:shop][:goods_num])

      shop.dsrs.create(logistics_score: data[:shop][:dsr][:logistics_score],
                       desc_score: data[:shop][:dsr][:desc_score],
                       service_score: data[:shop][:dsr][:service_score],
                       desc_rank_percent: data[:shop][:dsr][:desc_rank_percent],
                       service_rank_percent: data[:shop][:dsr][:service_rank_percent],
                       logistics_rank_percent: data[:shop][:dsr][:logistics_rank_percent],
                       desc_rank_status: data[:shop][:dsr][:desc_rank_status],
                       service_rank_status: data[:shop][:dsr][:service_rank_status],
                       logistics_rank_status: data[:shop][:dsr][:logistics_rank_status])

      goods = shop.goods.find_or_create_by(spu_id: data[:goods][:id])
      goods.goods_extras.create(good_id: goods.id,
                                name: data[:goods][:name],
                                sales_num: data[:goods][:sales_num],
                                comments_total_num: data[:goods][:comments][:comments_num])

      goods.goods_images.create(goods_images: data[:goods][:images].map { |image| image })
      goods.coupons.create(coupons: data[:goods][:coupons].map { |coupon| coupon[:name] })
      goods.mall_services.create(services: data[:goods][:services].map { |service| service[:name] })
      data[:goods][:comments][:details].each do |comment|
        goods.goods_comments.create(customer_name: comment[:customer_name],
                                    comment: comment[:comment],
                                    time: comment[:time])
      end

      data[:goods][:skus].each do |sku|
        _sku = goods.skus.find_or_create_by(skuid: sku[:skuid])

        _sku.skus_extras.create(sku_id: _sku.id,
                                spec: sku[:spec],
                                normal_price: sku[:normal_price],
                                group_price: sku[:group_price])
      end
    end

    private

    def handle(response)
      begin
        raw_data = response.scan(/<script>.*window.rawData.*?({.*?);\s*<\/script>/m).join('')
        json_data = JSON.load(raw_data)
        raise Robot::PDDWebSpider::NeedLoginException if json_data['store']['initDataObj'].has_key?('needLogin')
      rescue JSON::ParserError => e
        logger.error(e)
        raise Robot::WebSpider::ParseException
      rescue StandardError => e
        logger.error(e)
        raise e
      end
      json_data
    end

    # 把数据转化成系统需要的格式
    def transform_data(raw_data)
      data = handle(raw_data)
      data = data['store']['initDataObj']
      shop = data['mall']
      goods = data['goods']
      comments = data['oakData']

      {
        useAgent: data['userAgent'],
        shop: {
          id: shop['mallID'],
          name: shop['mallName'],
          goods_num: shop['goodsNum'],
          shop_url: shop['pddRoute'],
          sales_num: shop['salesTip'],
          dsr: {
            logistics_score: shop['dsr']['logisticsScore'],
            desc_score: shop['dsr']['descScore'],
            service_score: shop['dsr']['serviceScore'],
            desc_rank_percent: shop['dsr']['descRankPercent'],
            service_rank_percent: shop['dsr']['serviceRankPercent'],
            logistics_rank_percent: shop['dsr']['logisticsRankPercent'],
            desc_rank_status: shop['dsr']['descRankStatus'],
            service_rank_status: shop['dsr']['serviceRankStatus'],
            logistics_rank_status: shop['dsr']['logisticsRankStatus']
          }
        },
        goods: {
          id: goods['goodsID'],
          name: goods['goodsName'],
          images: goods['viewImageData'],
          sales_num: goods['sideSalesTip'],
          coupons: data['lisbonInfo']['mallCoupons'].map do |coupon|
                     {
                       name: coupon['batchName']
                     }
                   end,
          services: goods['mallService']['service'].map do |service|
                      {
                        name: service['type']
                      }
                    end,
          comments: {
            comments_num: comments['review']['commentNumText'],
            details: comments['review']['detailList'].map do |detail|
                       {
                         customer_name: detail['name'],
                         comment: detail['comment'],
                         time: detail['time']
                       }
                     end
          },
          skus: goods['skus'].map do |sku|
                  {
                    skuid: sku['skuID'],
                    normal_price: sku['normalPrice'],
                    group_price: sku['groupPrice'],
                    spec: sku['specs'].map { |spec| spec['spec_value'] }.join("\x20")
                  }
                end
        }
      }
    end
  end
end
