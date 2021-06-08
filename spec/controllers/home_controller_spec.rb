require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  shared_examples 'user access to home' do
    login_user

    describe 'GET #index' do
      it 'access to root path' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'return result with params' do
        obj = double('')
        allow(obj).to receive(:abc).with("123").and_return('result')
        expect(obj.abc('123')).to eq 'result'
      end

      it 'has correct response headers' do
        get :index
        expect(response.headers['X-Frame-Options']).to eq 'SAMEORIGIN'
        expect(response.headers['Content-Type']).to match(/text\/html; charset=utf-8/)
      end

      it 'has correct ENV' do
        stub_const("ENV", "RACK_ENV" => "test")
        expect(ENV['RACK_ENV']).to eq 'test'
      end

      it 'assigns the requested rss list to @rss_list' do
        # expect(assigns(:rss_list)).to eq rss_list
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template('index.web')
      end
    end
  end

  shared_examples 'guess access to home' do
    describe 'GET #index' do
      it 'redirect to sign in path' do
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'user access to home' do
    it_behaves_like 'user access to home'
  end

  describe 'guess access to home' do
    it_behaves_like 'guess access to home'
  end
end
