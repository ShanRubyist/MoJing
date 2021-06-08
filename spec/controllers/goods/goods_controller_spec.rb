require 'rails_helper'

RSpec.describe Goods::GoodsController, type: :controller do
  login_user

  describe 'GET #coupons' do
    describe 'with valid params' do
      it 'return coupons in json format' do
        get :coupons, params: { good_id: 1 }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      it 'return coupons in json format' do
        get :coupons
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
  
  # describe 'GET #prices' do
  #   describe 'with valid params' do
  #     it 'return prices in json format' do
  #       get :prices, params: { good_id: 1 }
  #       expect(response).to have_http_status(:success)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end
  #
  #   describe 'with invalid params' do
  #     it 'return prices in json format' do
  #       get :prices
  #       expect(response).to have_http_status(:success)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end
  # end

  describe 'GET #ads' do
    describe 'with valid params' do
      it 'return ads in json format' do
        get :ads, params: { good_id: 1 }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      it 'return ads in json format' do
        get :ads
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
  
  describe 'GET #comments' do
    describe 'with valid params' do
      it 'return comments in json format' do
        get :comments, params: { good_id: 1 }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      it 'return comments in json format' do
        get :comments
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
  
  describe 'GET #names' do
    describe 'with valid params' do
      it 'return names in json format' do
        get :names, params: { good_id: 1 }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      it 'return names in json format' do
        get :names
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
