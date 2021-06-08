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

  it '渲染 index.mobile.html.erb 模板' do
    pending '需要修复运行错误'
    render template: 'home/index.mobile.html.erb', locals: { current_user: @user }
    expect(rendered).to eq 'abc'
  end

  it '渲染 nav.html.erb 模板' do
    email = 'me@example.com'
    klass = Struct.new(:email)

    render partial: 'common/nav.html.erb', locals: { current_user: klass.new(email) }
    expect(rendered).to match(/#{email}/)
  end

  it '渲染 plain 文本' do
    render plain: 'spec test'
    expect(rendered).to eq 'spec test'
  end
end