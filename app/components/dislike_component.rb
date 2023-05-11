# frozen_string_literal: true

class DislikeComponent < ApplicationComponent
  attr_reader :video

  def initialize(video:)
    @video = video
  end
end
