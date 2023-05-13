# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoComponent, type: :component do
  let(:video) { create :video, channel_name: "Channel Name", title: "Video Title", description: "Description", thumbnails: { high: { url: "url" } } }

  it "renders component" do
    render_inline(described_class.new(video: video))

    expect(page).to have_selector("#video_#{video.id}")
    expect(page).to have_selector("h2", text: "Channel Name")
    expect(page).to have_selector("h3.font-medium", text: "Video Title")
    expect(page).to have_selector("h3", text: "Shared by: #{video.creator.email}")
    expect(page).to have_selector("p.text-sm", text: "Description")
  end
end
