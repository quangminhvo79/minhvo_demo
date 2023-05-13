# frozen_string_literal: true

require "rails_helper"

RSpec.describe LikeComponent, type: :component do
  let(:video) { create(:video) }
  let!(:video_reaction) { create(:video_reaction, video: video, user: user, kind: 'like') }
  let(:user) { create(:user) }

  context 'when have like reaction' do
    context 'when reaction belongs to current_user' do
      before do
        Current.current_user = user
      end
      it "renders like icon and amount of like" do
        render_inline(described_class.new(video: video))

        expect(page).to have_selector("#video-like-reaction-#{video.id}", text: 1)
        expect(page.find('img.cursor-pointer')["src"]).to include 'assets/like_active'
        expect(page.find('a[data-turbo-method=delete]')["href"]).to eq "/videos/#{video.id}/reactions/#{video_reaction.id}"
      end
    end

    context 'when reaction not belongs to current_user' do
      it "renders like icon and amount of like" do
        render_inline(described_class.new(video: video))

        expect(page).to have_selector("#video-like-reaction-#{video.id}", text: 1)
        expect(page.find('img.cursor-pointer')["src"]).to include 'assets/like'
        expect(page.find('img.cursor-pointer')["src"]).not_to include 'assets/like_active'
        expect(page.find('a[data-turbo-method=post]')["href"]).to eq "/videos/#{video.id}/reactions/like"
      end
    end
  end

  context 'when have like reaction' do
    let!(:video_reaction) { create(:video_reaction, video: video, kind: 'dislike') }

    it "renders like icon and amount of like" do
      render_inline(described_class.new(video: video))

      expect(page).to have_selector("#video-like-reaction-#{video.id}", text: 0)
      expect(page.find('img.cursor-pointer')["src"]).to include 'assets/like'
      expect(page.find('a[data-turbo-method=post]')["href"]).to eq "/videos/#{video.id}/reactions/like"
    end
  end
end
