require 'rails_helper'

RSpec.describe JobsManagement::JobsManagementController, type: :controller do
  login_user

  describe 'GET #running_jobs_count' do
    it 'return running jobs count' do
      get :running_jobs_count, params: { format: 'json' }
      expect(response.content_type).to eq('application/json')
      expect(response.body).to match(/.*running_rss_jobs_count.*running_goods_jobs_count.*/)
    end
  end
end