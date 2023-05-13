# frozen_string_literal: true

require "rails_helper"

RSpec.describe DislikeComponent, type: :component do
  let(:video) { create(:video) }
  let!(:video_reaction) { create(:video_reaction, video: video, user: user, kind: 'dislike') }
  let(:user) { create(:user) }

  context 'when have dislike reaction' do
    context 'when reaction belongs to current_user' do
      before do
        Current.current_user = user
      end
      it "renders dislike icon and amount of dislike" do
        render_inline(described_class.new(video: video))

        expect(page).to have_selector("#video-dislike-reaction-#{video.id}", text: 1)
        expect(page.find('img.cursor-pointer')["src"]).to include 'assets/dislike_active'
        expect(page.find('a[data-turbo-method=delete]')["href"]).to eq "/videos/#{video.id}/reactions/#{video_reaction.id}"
      end
    end

    context 'when reaction not belongs to current_user' do
      it "renders dislike icon and amount of dislike" do
        render_inline(described_class.new(video: video))

        expect(page).to have_selector("#video-dislike-reaction-#{video.id}", text: 1)
        expect(page.find('img.cursor-pointer')["src"]).to include 'assets/dislike'
        expect(page.find('img.cursor-pointer')["src"]).not_to include 'assets/dislike_active'
        expect(page.find('a[data-turbo-method=post]')["href"]).to eq "/videos/#{video.id}/reactions/dislike"
      end
    end
  end

  context 'when have dislike reaction' do
    let!(:video_reaction) { create(:video_reaction, video: video, kind: 'like') }

    it "renders dislike icon and amount of dislike" do
      render_inline(described_class.new(video: video))

      expect(page).to have_selector("#video-dislike-reaction-#{video.id}", text: 0)
      expect(page.find('img.cursor-pointer')["src"]).to include 'assets/dislike'
      expect(page.find('a[data-turbo-method=post]')["href"]).to eq "/videos/#{video.id}/reactions/dislike"
    end
  end
end
