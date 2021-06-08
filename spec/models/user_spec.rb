require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @probe_setting = FactoryBot.create(:probe_setting, users: [@user])
  end

  it 'should respond to probe_settings' do
    expect(FactoryBot.build(:user)).to respond_to(:probe_settings)
    expect(@user.probe_settings).to eq [@probe_setting]
  end

  it 'is invalid with dup user' do
    user = @user.dup
    expect(user).not_to be_valid
  end
end
