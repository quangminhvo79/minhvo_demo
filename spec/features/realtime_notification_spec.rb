require 'rails_helper'

RSpec.feature "Realtime notifications flow", type: :feature do
  let!(:user) { create :user, password: '12345678' }
  let!(:other_user) { create :user, email: 'other@user.com' }

  let!(:video) { create :video, title: 'Video Title', youtube_video_id: 'YoutubeIDaa', creator: user }

  scenario 'User can see videos shared without login' do
    visit root_path

    expect(page).to have_selector('.group', count: 1)
  end

  scenario 'After login, user will be receive notify about new video shared', :js do
    visit root_path
    login(user)

    Video.create(title: 'New Video', youtube_video_id: "YoutubeIDaa", creator: other_user)
    expect(page).to have_content('other@user.com shared a Video New Video')
  end

  scenario 'Without login, user will not receive notify about new video shared', :js do
    visit root_path

    Video.create(title: 'New Video', youtube_video_id: "YoutubeIDaa", creator: other_user)
    expect(page).not_to have_content('other@user.com shared a Video New Video')
  end

  scenario 'The owner of video will be receive notify when other user reaction on their video', :js do
    visit root_path

    login(user)
    video.create_reaction(kind: :like, user: other_user)
    expect(page).not_to have_content('other@user.com like your Video: Video Title')
  end
end

