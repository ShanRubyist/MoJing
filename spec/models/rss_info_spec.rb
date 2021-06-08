require 'rails_helper'

RSpec.describe RssInfo, type: :model do
  before do
    @probe_setting = FactoryBot.create(:probe_setting)
    @rss = FactoryBot.create(:rss_info, probe_setting: @probe_setting)
  end

  it 'should respond to probe_setting' do
    expect(@rss).to respond_to(:probe_setting)
    expect(@rss.probe_setting).to eq @probe_setting
  end

  it 'is invalid without a probe_setting_id' do
    rss = RssInfo.new()
    expect(rss).not_to be_valid
  end
end
