require 'rails_helper'

RSpec.feature 'Share Youtube video flow' do
  let!(:video) { create :video, title: 'Video Title', youtube_video_id: 'YoutubeIDaa' }

  scenario 'when a video present, the user can access the video detail page.' do
    visit root_path

    click_on 'Video Title'

    expect(page.current_path).to eq video_path(video)
    expect(page).to have_content('Video Title')
  end

  scenario 'when a video does not exist, the user cannot access the video detail page.' do
    visit video_path(id: :not_found)

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
