require 'rails_helper'

RSpec.describe Histories::HistoriesController, type: :controller do
  login_user

  describe 'GET #histories' do
    it 'proxy to rss histories' do
      spy_controller = spy(controller)
      get :histories, params: { type: 0, setting_id: 1 }
      # expect(spy_controller).to have_received(:rss_histories)
    end
  end
end
