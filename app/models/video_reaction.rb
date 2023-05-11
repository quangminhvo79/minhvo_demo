# frozen_string_literal: true

class VideoReaction < ApplicationRecord
  TYPES = %w[like dislike]

  belongs_to :user
  belongs_to :video

  validates :kind, inclusion: { in: TYPES }

  scope :likes, -> { where(kind: :like) }
  scope :dislikes, -> { where(kind: :dislike) }

  after_commit :send_notification

  def self.liked?(user:)
    likes.exists?(user: user)
  end

  def self.disliked?(user:)
    dislikes.exists?(user: user)
  end

  private

  def send_notification
    return unless self.persisted?

    message = { notice: I18n.t('reaction_notification_messages', user_email: user.email,
                                                                title: video.title,
                                                                youtube_video_id: video.youtube_video_id,
                                                                reaction_kind: kind.humanize).html_safe }

    broadcast_append_to("true:reactions", target: "notifications", partial: 'notifications/new', locals: { message: message })
  end
end
