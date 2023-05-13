require 'rails_helper'

RSpec.describe ReactionsController, type: :request do
  let(:user) { create(:user) }
  let(:video) { create(:video, creator: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    sign_in user
  end

  describe '#like' do
    it 'creates a like reaction on the video' do
      expect {
        post "/videos/#{video.id}/reactions/like", xhr: true
      }.to change { video.reactions.count }.from(0).to(1)

      expect(video.reactions.first.kind).to eq('like')
      expect(video.reactions.first.user).to eq(user)
    end
  end

  describe '#dislike' do
    it 'creates a dislike reaction on the video' do
      expect {
        post "/videos/#{video.id}/reactions/dislike", xhr: true
      }.to change { video.reactions.count }.from(0).to(1)

      expect(video.reactions.first.kind).to eq('dislike')
      expect(video.reactions.first.user).to eq(user)
    end
  end

  describe '#destroy' do
    let!(:reaction) { VideoReaction.create(user: user, kind: 'like', video: video) }

    it 'destroys the reaction for the current user' do
      expect {
        delete "/videos/#{video.id}/reactions/#{reaction.id}", xhr: true
      }.to change { video.reactions.count }.from(1).to(0)

      expect { reaction.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
