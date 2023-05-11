# frozen_string_literal: true

class VideoReaction < ApplicationRecord
  TYPES = %w[like dislike]

  belongs_to :user
  belongs_to :video

  validates :kind, inclusion: { in: TYPES }

  scope :likes, -> { where(kind: :like) }
  scope :dislikes, -> { where(kind: :dislike) }

  def self.liked?(user:)
    likes.exists?(user: user)
  end

  def self.disliked?(user:)
    dislikes.exists?(user: user)
  end
end
