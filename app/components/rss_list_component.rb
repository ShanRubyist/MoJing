# frozen_string_literal: true

class RssListComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(rss_list:, current_user:)
    @rss_list = rss_list
    @current_uer = current_user
  end

  def current_user
    @current_uer
  end
end
