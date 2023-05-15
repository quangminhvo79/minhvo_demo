# frozen_string_literal: true

module Youtube
  class VideoCreator < ApplicationService
    validates :youtube_url, :user, presence: true

    def initialize(youtube_url:, user:)
      @youtube_url = youtube_url
      @user = user
    end

    def perform
      return false unless valid?

      ActiveRecord::Base.transaction do
        unless video_attributes
          copy_errors_from(video_snippet_service)
          return false
        end

        Video.create!(video_attributes.merge(creator: user))
      end

      true
    rescue StandardError => e
      Rails.logger.error e.backtrace.join("\n")
      expose_errors(e.message)
    end

    private

    attr_reader :youtube_url, :user

    def video_attributes
      @video_attributes ||= video_snippet_service.load
    end

    def video_snippet_service
      @service ||= Youtube::VideoSnippet.new(youtube_video_id: youtube_video_id)
    end

    def youtube_video_id
      youtube_url[%r{(?<=v=|/)([a-zA-Z0-9_-]{11})(?=&|\?|$)}]
    end
  end
end
