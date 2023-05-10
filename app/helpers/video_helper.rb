# frozen_string_literal: true

module VideoHelper
  def youtube_url(youtube_video_id = nil)
    ['https://youtu.be/', youtube_video_id].join
  end
end
