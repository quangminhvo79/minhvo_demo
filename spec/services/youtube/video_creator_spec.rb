require 'rails_helper'

RSpec.describe Youtube::VideoCreator do
  let(:user) { create(:user) }
  let(:youtube_url) { 'https://www.youtube.com/watch?v=YoutubeIDID' }
  subject { described_class.new(youtube_url: youtube_url, user: user) }

  describe '#perform' do
    context 'when not given a URL' do
      let(:youtube_url) { nil }

      it 'returns false' do
        expect(subject.perform).to be false
      end
    end

    context 'when not given a User' do
      let(:user) { nil }

      it 'returns false' do
        expect(subject.perform).to be false
      end
    end

    context 'when given a valid URL and user' do
      let(:service) { double(Youtube::VideoSnippet, load: { title: 'Youtube Title', youtube_video_id: 'YoutubeIDID' }) }

      before do
        expect(Youtube::VideoSnippet).to receive(:new).with(youtube_video_id: 'YoutubeIDID').and_return(service)
      end

      it 'creates a new video and returns true' do
        expect {
          expect(subject.perform).to be(true)
        }.to change { Video.count }.by(1)

        video = Video.last
        expect(video.creator).to eq(user)
        expect(video.title).to eq('Youtube Title')
      end
    end

    context 'when given an invalid URL' do
      let(:youtube_url) { 'not a valid YouTube URL' }

      it 'returns false and logs an error' do
        expect(subject.perform).to be(false)
        expect(subject.error_sentence).to eq("Youtube video Invalid")
      end
    end

    context 'when the video snippet service fails to load attributes' do
      let(:error) { double(:error, attribute: :youtube_snippet, message: 'API error') }
      let(:service) { double(Youtube::VideoSnippet, load: false, errors: [error]) }

      before do
        expect(Youtube::VideoSnippet).to receive(:new).with(youtube_video_id: 'YoutubeIDID').and_return(service)
      end

      it 'returns false and copies errors from the service' do
        expect(subject.perform).to be(false)
        expect(subject.error_sentence).to eq "Youtube snippet API error"
      end
    end

    context 'when an error occurs' do
      let(:service) { double(Youtube::VideoSnippet, load: { title: 'Youtube Title', youtube_video_id: 'YoutubeIDID' }) }

      before do
        expect(Youtube::VideoSnippet).to receive(:new).with(youtube_video_id: 'YoutubeIDID').and_return(service)
        expect(Video).to receive(:create!).and_raise(StandardError.new('Uh oh, something went wrong'))
        expect(Rails.logger).to receive(:error)
      end

      it 'logs the error and returns false' do
        expect(subject.perform).to be(false)
      end
    end
  end
end
