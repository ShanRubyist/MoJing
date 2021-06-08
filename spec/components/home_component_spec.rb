require "rails_helper"

RSpec.describe HomeComponent, type: :component do
  it 'renders home page' do
    expect(
        render_inline(HomeComponent.new {}).css('span').to_html
    ).to include('RSS')
  end
end
