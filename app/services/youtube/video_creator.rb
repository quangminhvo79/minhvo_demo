# frozen_string_literal: true

class Youtube::VideoCreator < ApplicationService
  validates :youtube_url, :user, presence: true

  def initialize(youtube_url:, user:)
    @youtube_url = youtube_url
    @user = user
  end

  def perform
    return false                       unless valid?
    return expose_video_snippet_error  unless video_attributes

    ActiveRecord::Base.transaction do
      Video.create!(video_attributes.merge(creator: user))
    end

    true
  rescue StandardError => e
    Rails.logger.error e.backtrace.join("\n")

    expose_errors(e)
  end

  private

  attr_reader :youtube_url, :user

  def expose_video_snippet_error
    expose_errors(video_snippet_service.errors.full_messages)
  end

  def video_snippet_service
    @video_snippet_service ||= Youtube::VideoSnippet.new(youtube_video_id: youtube_video_id)
  end

  def video_attributes
    @video_attributes ||= video_snippet_service.load
  end

  def youtube_video_id
    youtube_url[%r{(?<=v=|/)([a-zA-Z0-9_-]{11})(?=&|\?|$)}]
  end
end
