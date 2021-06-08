# frozen_string_literal: true

class AddDiaglogComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(current_user:)
    @current_uer = current_user
  end

  def current_user
    @current_uer
  end
end
