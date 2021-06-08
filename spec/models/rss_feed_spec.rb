require 'rails_helper'

RSpec.describe RssFeed, type: :model do
  before do
    @probe_setting = FactoryBot.create(:probe_setting)
    @feed1 = FactoryBot.create(:rss_feed1, probe_setting: @probe_setting)
  end

  it 'should respond to probe_setting' do
    expect(@feed1).to respond_to(:probe_setting)
    expect(@feed1.probe_setting).to eq @probe_setting
  end
end
