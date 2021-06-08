require 'rails_helper'

RSpec.describe 'GoodsController', type: :routing do
  describe 'routing' do

    it 'routes to #prices' do
      expect(get: "/goods/prices").to route_to("goods/goods#prices")
    end

    it 'routes to #comments' do
      expect(get: "/goods/comments").to route_to("goods/goods#comments")
    end

    it 'routes to #coupons' do
      expect(get: "/goods/coupons").to route_to("goods/goods#coupons")
    end

    it 'routes to #ads' do
      expect(get: "/goods/ads").to route_to("goods/goods#ads")
    end

    it 'routes to #names' do
      expect(get: "/goods/names").to route_to("goods/goods#names")
    end
  end
end