require 'rails_helper'

RSpec.feature 'Share Youtube video flow' do
  let!(:user) { create :user, password: '12345678' }
  let!(:video1) { create :video, title: 'Video Title 1', youtube_video_id: 'YoutubeIDaa', creator: user }
  let!(:video2) { create :video, title: 'Video Title 2', youtube_video_id: 'YoutubeIDbb', creator: user }
  let!(:video3) { create :video, title: 'Video Title 3', youtube_video_id: 'YoutubeIDcc' }
  let!(:video4) { create :video, title: 'Video Title 4', youtube_video_id: 'YoutubeIDdd' }

  scenario 'User can see videos shared without login' do
    visit root_path

    within('#video_list') do
      expect(page).to have_selector('.group', count: 4)
      expect(page).to have_selector("#video_#{video2.id}")
      expect(page).to have_selector("#video_#{video3.id}")
      expect(page).to have_selector("#video_#{video4.id}")
    end
  end

  context "User can share video after logged-in" do
    context 'when share video successfully' do
      let(:service) { double('Youtube::VideoSnippet', load: result) }
      let(:result) do
        {
          title: 'Video New',
          description: 'Video Description',
          youtube_video_id: 'YoutubeIDee',
          thumbnails: {
            'default' => { 'url' => 'https://i.ytimg.com/vi/5yTliSaFp5o/default.jpg', 'width' => 120, 'height' => 90 },
            'medium' => { 'url' => 'https://i.ytimg.com/vi/5yTliSaFp5o/mqdefault.jpg', 'width' => 320,
                          'height' => 180 },
            'high' => { 'url' => 'https://i.ytimg.com/vi/5yTliSaFp5o/hqdefault.jpg', 'width' => 480, 'height' => 360 },
            'standard' => { 'url' => 'https://i.ytimg.com/vi/5yTliSaFp5o/sddefault.jpg', 'width' => 640,
                            'height' => 480 },
            'maxres' => { 'url' => 'https://i.ytimg.com/vi/5yTliSaFp5o/maxresdefault.jpg', 'width' => 1280, 'height' => 720 }
          }.with_indifferent_access
        }
      end

      before do
        expect(Youtube::VideoSnippet).to receive(:new).with(youtube_video_id: 'YoutubeIDee').and_return(service)
      end

      scenario 'should be share video successfully', :js do
        visit root_path

        login(user)

        click_on 'Share Video'

        fill_in 'video_youtube_url', with: 'https://www.youtube.com/watch?v=YoutubeIDee'
        click_on 'Share'

        expect(page).to have_content('Share Youtube video successfully')
        expect(page).to have_content('Video New')
      end

      context "When users share a video they've already shared", :js do
        let!(:video4) { create :video, title: 'Video Title 4', youtube_video_id: 'YoutubeIDee', creator: user }

        scenario "should not share a video they've already shared" do
          visit root_path

          login(user)

          click_on 'Share Video'

          fill_in 'video_youtube_url', with: 'https://www.youtube.com/watch?v=YoutubeIDee'
          click_on 'Share'

          expect(page).to have_content("Validation failed: Youtube video cannot share twice")
        end
      end

      context 'When other user share video that existed', :js do
        let!(:video4) { create :video, title: 'Video Title 4', youtube_video_id: 'YoutubeIDee', creator: create(:user) }

        scenario 'should be share video successfully' do
          visit root_path

          login(user)

          click_on 'Share Video'

          fill_in 'video_youtube_url', with: 'https://www.youtube.com/watch?v=YoutubeIDee'
          click_on 'Share'

          expect(page).to have_content('Share Youtube video successfully')
        end
      end
    end

    scenario 'User cannot share video with wrong Youtube URL', :js do
      visit root_path

      login(user)

      click_on 'Share Video'

      fill_in 'video_youtube_url', with: 'https://www.youtube.com'
      click_on 'Share'

      expect(page).to have_content('Youtube video invalid')
    end

    context 'When Youtube API invalid', :js do
      before do
        expect(HTTParty).to receive(:get).and_return({ error: { message: 'The API Key invalid!' } })
      end

      scenario 'should not share video when Youtube API key invalid' do
        visit root_path

        login(user)

        click_on 'Share Video'

        fill_in 'video_youtube_url', with: 'https://www.youtube.com/watch?v=YoutubeIDee'
        click_on 'Share'

        expect(page).to have_content('The API Key invalid!')
      end
    end
  end
end
