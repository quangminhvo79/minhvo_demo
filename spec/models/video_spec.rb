require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:creator).class_name('User') }
    it { is_expected.to have_many(:reactions).class_name('VideoReaction').dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:video)}
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:youtube_video_id).with_message("can't be blank or wrong video link") }
    it { is_expected.to validate_uniqueness_of(:youtube_video_id).scoped_to(:creator_id).with_message("cannot share twice") }
  end

  describe '#create_reaction' do
    let(:user) { create(:user) }
    let(:video) { create(:video) }

    context 'when user has not reacted yet' do
      it 'creates a new reaction' do
        expect {
          video.create_reaction(kind: 'like', user: user)
        }.to change(VideoReaction, :count).by(1)
      end

      it 'sets the correct attributes on the reaction' do
        video.create_reaction(kind: 'dislike', user: user)
        reaction = video.reactions.find_by(user: user)

        expect(reaction.kind).to eq('dislike')
      end
    end

    context 'when user has already reacted' do
      before do
        create(:video_reaction, user: user, video: video, kind: 'like')
      end

      it 'updates the existing reaction' do
        expect {
          video.create_reaction(kind: 'dislike', user: user)
        }.to_not change(VideoReaction, :count)

        reaction = video.reactions.find_by(user: user)
        expect(reaction.kind).to eq('dislike')
      end
    end
  end

  describe '#send_notification' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let(:video) { Video.new(creator: user1, title: 'title', youtube_video_id: '123123') }

    before do
      allow(ActionCable.server).to receive(:broadcast)
      allow(video).to receive(:message).and_return('Test message')
    end

    it 'creates a notification' do
      expect(Notification).to receive(:create).with(
        message: "Test message",
        user: user2,
        notificationable: video
      )

      video.save
    end

    it 'push a notification to all users except the creator' do
      expect(video).to receive(:broadcast_append_to).with(
        user2,
        :videos,
        target: "notifications",
        partial: 'notifications/new',
        locals: { message: { notice: 'Test message'.html_safe }, user: user2 }
      )

      video.save

      expect(user2.notifications.count).to eq(1)

      notification = user2.notifications.first

      expect(notification.message).to eq 'Test message'
    end
  end
end
