# frozen_string_literal: true

module Goods
  class GoodsController < ApplicationController
    include GoodsReadable

    def coupons
      if good = Coupon.includes(:good)
                    .where(goods: {spu_id: params[:good_id]})
                    .order('coupons.created_at asc')
        rst = detail_change_history(good, :coupons, :created_at)
        render json: rst.to_json
      else
        render json: {}
      end
    end

    def ads;
      render json: {}
    end

    def names
      if good = GoodsExtra.includes(:good)
                    .where(goods: {spu_id: params[:good_id]})
                    .order('goods_extras.created_at asc')

        rst = detail_change_history(good, :name, :created_at)
        render json: rst.to_json
      else
        render json: {}
      end
    end

    def prices
      if good = SkusExtra.includes(sku: :good).where(goods: {spu_id: params[:good_id]})
        specs = good.map(&:spec).uniq!

        return unless specs
        rlt = {
            legend: specs,
            data: specs.map do |spec|
              {
                  spec: spec,
                  prices: SkusExtra.where('spec = ?', spec)
                              .order('created_at asc')
                              .last(7)
                              .map(&:group_price)
              }
            end,
            time: SkusExtra.where('spec = ?', specs.first)
                      .order('skus_extras.created_at asc')
                      .last(7)
                      .map { |item| item.created_at.localtime.strftime('%Y-%m-%d %H:%M') }
        }
        render json: rlt.to_json
      else
        render json: {}
      end
    end

    def comments
      if good = GoodsExtra.includes(:good).where(goods: {spu_id: params[:good_id]})

        rlt = {
            data: good.order('goods_extras.created_at asc')
                      .last(7)
                      .map(&:comments_total_num),
            time: good.order('goods_extras.created_at asc')
                      .last(7)
                      .map { |item| item.created_at.localtime.strftime('%Y-%m-%d %H:%M') }
        }
        render json: rlt.to_json
      else
        render json: {}
      end
    end
  end
end
