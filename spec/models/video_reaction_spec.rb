require 'rails_helper'

RSpec.describe VideoReaction, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:kind).in_array(VideoReaction::TYPES) }
  end

  describe 'scopes' do
    let!(:like_reaction) { create(:video_reaction, kind: 'like') }
    let!(:dislike_reaction) { create(:video_reaction, kind: 'dislike') }

    describe '.likes' do
      it 'returns only like reactions' do
        expect(described_class.likes).to contain_exactly(like_reaction)
      end
    end

    describe '.dislikes' do
      it 'returns only dislike reactions' do
        expect(described_class.dislikes).to contain_exactly(dislike_reaction)
      end
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:video) { create(:video) }

    describe '.liked?' do
      context 'when user has liked the video' do
        before do
          create(:video_reaction, user: user, video: video, kind: 'like')
        end

        it 'returns true' do
          expect(described_class.liked?(user: user)).to be_truthy
        end
      end

      context 'when user has not liked the video' do
        before do
          create(:video_reaction, user: user, video: video, kind: 'dislike')
        end

        it 'returns false' do
          expect(described_class.liked?(user: user)).to be_falsey
        end
      end
    end

    describe '.disliked?' do
      context 'when user has disliked the video' do
        before do
          create(:video_reaction, user: user, video: video, kind: 'dislike')
        end

        it 'returns true' do
          expect(described_class.disliked?(user: user)).to be_truthy
        end
      end

      context 'when user has not disliked the video' do
        before do
          create(:video_reaction, user: user, video: video, kind: 'like')
        end

        it 'returns false' do
          expect(described_class.disliked?(user: user)).to be_falsey
        end
      end
    end
  end

  describe '#send_notification' do
    let!(:user) { create(:user) }
    let!(:video) { create(:video, creator: user) }
    let!(:video_reaction) { create(:video_reaction, video: video, user: user, kind: 'like') }

    context 'when the object is not persisted' do
      it 'does not create a notification' do
        allow(subject).to receive(:persisted?).and_return(false)

        expect(Notification).not_to receive(:create)
        subject.send :send_notification
      end
    end

    context 'when the current user is reaction in video of them' do
      it 'does not create a notification' do
        allow(Current).to receive(:current_user).and_return(video.creator)

        expect(Notification).not_to receive(:create)
        subject.send :send_notification
      end
    end

    context 'when the notification is created successfully' do
      before do
        allow(video_reaction).to receive(:message).and_return('Test message')
        allow(ActionCable.server).to receive(:broadcast)
        Current.current_user = create(:user)
      end

      it 'creates a notification' do
        expect(Notification).to receive(:create).with(
          message: "Test message",
          user: video.creator,
          notificationable: video_reaction
        )

        video_reaction.send :send_notification
      end

      it 'pushes a notification to the user' do
        expect(video_reaction).to receive(:broadcast_append_to).with(
          video.creator,
          :reactions,
          target: "notifications",
          partial: 'notifications/new',
          locals: { message: { notice: 'Test message'.html_safe } }
        )

        video_reaction.send :send_notification
      end

      it 'update notification list of the user' do
        expect(video_reaction).to receive(:broadcast_update_to).with(
          video.creator,
          :reactions,
          target: 'notify-list',
          partial: 'notifications/list',
          locals: { user: video.creator }
        )

        video_reaction.send :send_notification
      end
    end
  end

  describe '#update_reaction' do
    let!(:user) { create(:user) }
    let!(:video) { create(:video, creator: user) }
    let!(:video_reaction) { create(:video_reaction, video: video, user: user, kind: 'like') }

    context 'when reaction committed' do
      it "update reaction count in other side" do
        expect(video_reaction).to receive(:broadcast_update_to).with(
          :update_reaction,
          target: "video-like-reaction-#{video.id}",
          html: video.reactions.likes.size
        )

        expect(video_reaction).to receive(:broadcast_update_to).with(
          :update_reaction,
          target: "video-dislike-reaction-#{video.id}",
          html: video.reactions.dislikes.size
        )

        video_reaction.send :update_reaction
      end
    end
  end
end
