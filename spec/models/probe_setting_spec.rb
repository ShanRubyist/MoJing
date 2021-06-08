require 'rails_helper'

RSpec.describe ProbeSetting, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @probe_setting = FactoryBot.create(:probe_setting, users: [@user])
    @feed1 = FactoryBot.create(:rss_feed1, probe_setting: @probe_setting)
    @feed2 = FactoryBot.create(:rss_feed2, probe_setting: @probe_setting)
  end

  it 'is invalid without a url' do
    # expect{FactoryBot.build(:invalid_probe_setting)}.to have(1).errors_on(:url)
    expect(FactoryBot.build(:invalid_probe_setting)).not_to be_valid
  end

  it 'is valid with a url' do
    expect(FactoryBot.build(:probe_setting)).to be_valid
  end

  it 'should respond to url' do
    expect(FactoryBot.build(:probe_setting)).to respond_to(:url)
  end

  it 'should respond to rss_feeds' do
    expect(FactoryBot.build(:probe_setting)).to respond_to(:rss_feeds)
    expect(@probe_setting.rss_feeds).to eq [@feed1, @feed2]
  end

  it 'should respond to users' do
    expect(FactoryBot.build(:probe_setting)).to respond_to(:users)
    expect(@probe_setting.users).to eq [@user]
  end

  it 'get url' do
    expect(FactoryBot.build(:probe_setting).url).to eq('https://ruby-china.org/topics/feed')
  end
end
