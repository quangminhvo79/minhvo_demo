# frozen_string_literal: true

class Youtube::VideoSnippet < ApplicationService
  validates :youtube_video_id, presence: true

  YOUTUBE_ENDPOINT = 'https://youtube.googleapis.com/youtube/v3/videos'

  def initialize(youtube_video_id:)
    @youtube_video_id = youtube_video_id
  end

  def load
    return expose_invalid_error              unless valid?
    return expose_youtube_service_error      if video_info[:error].present?
    return expose_errors('Not Found')        if video_info[:items].blank?

    video_attributes
  rescue StandardError => e
    Rails.logger.error e.backtrace.join("\n")

    expose_errors(e)
  end

  private

  attr_reader :youtube_video_id

  def video_attributes
    {
      channel_name:     video_info[:items].first[:snippet][:channelTitle],
      title:            video_info[:items].first[:snippet][:title],
      description:      video_info[:items].first[:snippet][:description],
      youtube_video_id: video_info[:items].first[:id],
      thumbnails:       video_info[:items].first[:snippet][:thumbnails]
    }
  end

  def video_info
    @video_info ||= HTTParty.get(YOUTUBE_ENDPOINT, query: query_params,
                                                   headers: { 'Content-Type' => 'application/json' }).with_indifferent_access
  end

  def expose_invalid_error
    expose_errors('Input invalid')
  end

  def expose_youtube_service_error
    expose_errors(video_info[:error][:message])
  end

  def query_params
    {
      part:  'snippet',
      id:    youtube_video_id,
      key:   ENV['YOUTUBE_API_KEY']
    }
  end

  def valid?
    super && ENV['YOUTUBE_API_KEY'].present?
  end
end
