require 'rails_helper'

RSpec.describe Rss::RssFeedsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  login_user

  describe 'PUT #mark_read' do
    it 'mark all rss feed readed' do
      patch :mark_readed, params: {user_id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #load_more_rss_feed' do
    let(:user) { FactoryBot.create(:user) }
    let(:page) { 1 }
    let(:per) { 10 }

    it 'load more rss feed in text/html content type' do
      get :load_more_rss_feed, params: {user_id: user.id}
      expect(response.headers['Content-Type']).to have_content('application/json')
    end
  end

  describe 'GET #unread_count' do
    it 'return unread rss feed count' do
      get :unread_count, params: {user_id: user.id}
      expect(response).to have_http_status(:success)
      expect(response.headers['Content-Type']).to have_content('application/json')
      expect(response.body).to match(/.*unread_count.*:\d+.*/)
    end
  end
end
