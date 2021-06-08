# frozen_string_literal: true

class GoodsListComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(goods_list:)
    @goods_list = goods_list
  end

end
