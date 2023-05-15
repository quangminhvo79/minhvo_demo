require 'rails_helper'

RSpec.feature "Realtime notifications flow", type: :feature do
  let!(:user) { create :user, password: '12345678' }
  let!(:other_user) { create :user, email: 'other@user.com' }

  let!(:video) { create :video, title: 'Video Title', youtube_video_id: 'YoutubeIDaa', creator: user }

  context 'when user not login' do
    scenario 'user can see videos shared' do
      visit root_path

      expect(page).to have_selector('.group', count: 1)
    end

    scenario 'user will not receive notify about new video shared', :js do
      visit root_path

      Video.create(title: 'New Video', youtube_video_id: "YoutubeIDaa", creator: other_user)
      expect(page).not_to have_content("other@user.com shared a video New Video")
    end
  end

  context 'when user logged-in' do
    before do
      Current.current_user = user
    end

    scenario 'user will be receive notify about new video shared', :js do
      visit root_path
      login(user)

      Video.create(title: 'New Video', youtube_video_id: "YoutubeIDaa", creator: other_user)
      expect(page).to have_content("other@user.com shared a video New Video")

      page.find('#notification-list').execute_script("this.classList.add('active');")

      within('.dropdown-content') do
        expect(page).to have_selector('div.notification-item', text: 'other@user.com shared a video New Video')
      end
    end
  end

  context 'when user logged-in with other account' do
    before do
      Current.current_user = other_user
    end

    scenario 'the owner of video will be receive notify when other user reaction on their video', :js do
      visit root_path
      login(user)

      video.create_reaction(kind: :like, user: other_user)
      expect(page).to have_content('other@user.com like your video: Video Title')

      page.find('#notification-list').execute_script("this.classList.add('active');")

      within('.dropdown-content') do
        expect(page).to have_selector('div.notification-item', text: 'other@user.com like your video: Video Title')
      end
    end
  end
end

