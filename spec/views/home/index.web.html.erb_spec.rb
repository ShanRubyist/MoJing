require 'rails_helper'

RSpec.describe 'home/index', type: :view do
  before do
    @user = User.create!(FactoryBot.attributes_for(:user))
  end

  it '显示首页' do
    # assign(:rss_list, {})
    #
    # render
    # expect(rendered).to match(/abc/)
  end

  it '渲染 index.web.html.erb 模板' do
    render template: 'home/index.web.html.erb'
    expect(rendered.match(/sidebar/)).not_to eq nil
  end
end