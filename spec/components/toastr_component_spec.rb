# frozen_string_literal: true

require "rails_helper"

RSpec.describe ToastrComponent, type: :component do
  let(:flash) do
    {
      notice: 'This is notice',
      error: 'This is error'
    }
  end

  it "renders component" do
    render_inline(described_class.new(flash: flash))

    notice = page.find('.alert-success')
    expect(notice).to have_content 'This is notice'

    error = page.find('.alert-error')
    expect(error).to have_content 'This is error'
  end
end
