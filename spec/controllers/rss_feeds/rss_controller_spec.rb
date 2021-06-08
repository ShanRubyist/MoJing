require 'rails_helper'

RSpec.describe Rss::RssController, type: :controller do
  login_user

  describe 'GET #index' do
    it 'access to index path' do
      get :index
      expect(response).to render_template("index")
    end
  end
end


