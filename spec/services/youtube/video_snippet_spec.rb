require 'rails_helper'

RSpec.describe Youtube::VideoSnippet do
  describe '#load' do
    let(:youtube_video_id) { 'test' }
    subject { described_class.new(youtube_video_id: youtube_video_id) }

    context 'when given youtube_video_id to blank' do
      let(:youtube_video_id) { nil }

      it 'returns false' do
        expect(subject.load).to eq false
        expect(subject.error_sentence).to eq 'Youtube video invalid'
      end
    end

    context 'when the Youtube video not found' do
      before do
        expect(HTTParty).to receive(:get).and_return({ items: [] })
      end

      it 'returns false' do
        expect(subject.load).to eq false
        expect(subject.error_sentence).to eq 'Youtube-videosnippet Not Found'
      end
    end

    context 'when the video is available' do
      before do
        expect(HTTParty).to receive(:get).and_return({
          items: [{
            id: 'test',
            snippet: {
              channelTitle: 'Test Channel',
              title: 'Test Title',
              description: 'Test Description',
              thumbnails: {}
            }
          }]
        })
      end

      it 'returns the video attributes' do
        expect(subject.load).to eq({
          channel_name: 'Test Channel',
          title: 'Test Title',
          description: 'Test Description',
          youtube_video_id: 'test',
          thumbnails: {}
        })
      end
    end

    context 'when the video is not found' do
      before do
        expect(HTTParty).to receive(:get).and_return({
          error: {
            message: 'video not found'
          }
        })
      end

      it 'returns an error' do
        expect(subject.load).to eq(false)
        expect(subject.error_sentence).to eq('Youtube-videosnippet video not found')
      end
    end

    context 'when an exception is raised' do
      before { expect(HTTParty).to receive(:get).and_raise(StandardError) }

      it 'logs the error and returns an error' do
        expect(Rails.logger).to receive(:error)
        expect(subject.load).to eq(false)
      end
    end
  end
end
