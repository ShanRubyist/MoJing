require 'rails_helper'

RSpec.describe RunningJosbsCountable do
  let(:test_obj) {
    Class.new do
      include RunningJosbsCountable
    end.new
  }

  describe 'call running_rss_jobs_count' do
    it 'return running rss jobs count' do
      expect(test_obj.running_rss_jobs_count).to eq 0
    end
  end

  describe 'call running_goods_jobs_count' do
    it 'return running goods jobs count' do
      expect(test_obj.running_goods_jobs_count).to eq 0
    end
  end
end
