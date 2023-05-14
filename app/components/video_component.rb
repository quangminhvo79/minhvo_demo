# frozen_string_literal: true

class VideoComponent < ApplicationComponent
  attr_reader :video

  def initialize(video:)
    @video = video
  end
end
