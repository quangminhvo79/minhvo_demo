# frozen_string_literal: true

class Video < ApplicationRecord
  attr_accessor :youtube_url

  belongs_to :creator, class_name: 'User'
  has_many :reactions, class_name: 'VideoReaction'

  validates :title, presence: true
  validates :youtube_video_id, presence: { message: "can't be blank or wrong video link" },
                               uniqueness: { scope: :creator, message: "can't be share a video twice times" }

  def create_reaction(kind:, user:)
    reaction = reactions.where(user: user).first_or_initialize
    reaction.update(kind: kind)
  end
end
