# frozen_string_literal: true

class VideoComponent < ApplicationComponent
  attr_reader :video

  def initialize(video:)
    @video = video
  end

  def youtube_url(youtube_video_id = nil)
    ['https://youtu.be/', youtube_video_id].join
  end
end
