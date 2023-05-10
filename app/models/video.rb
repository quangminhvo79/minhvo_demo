# frozen_string_literal: true

class Video < ApplicationRecord
  attr_accessor :youtube_url

  belongs_to :creator, class_name: 'User'

  validates :title, presence: true
  validates :youtube_video_id, presence: { message: "can't be blank or wrong video link" },
                               uniqueness: { scope: :creator, message: "can't be share a video twice times" }

end
