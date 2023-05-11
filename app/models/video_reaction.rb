# frozen_string_literal: true

class VideoReaction < ApplicationRecord
  TYPES = %w[like dislike]

  belongs_to :user
  belongs_to :video

  has_many :notifications, as: :notificationable, dependent: :destroy

  validates :kind, inclusion: { in: TYPES }

  scope :likes, -> { where(kind: :like) }
  scope :dislikes, -> { where(kind: :dislike) }

  after_commit :send_notification
  after_commit :update_reaction

  def self.liked?(user:)
    likes.exists?(user: user)
  end

  def self.disliked?(user:)
    dislikes.exists?(user: user)
  end

  private

  def send_notification
    return unless self.persisted?
    return if Current.current_user == video.creator

    Notification.create(message: message, user: video.creator, notificationable: self)

    push_notification
    update_notification_list
  end

  def message
    I18n.t('reaction_notification_messages', user_email: user.email,
                                             title: video.title,
                                             youtube_video_id: video.youtube_video_id,
                                             reaction_kind: kind.humanize.downcase)
  end

  def push_notification
    broadcast_append_to(video.creator, :reactions, target: "notifications",
                                                   partial: 'notifications/new',
                                                   locals: { message: { notice: message.html_safe } })
  end

  def update_notification_list
    broadcast_update_to(video.creator, :reactions, target: "notify-list",
                                                   partial: 'notifications/list',
                                                   locals: { user: video.creator })
  end

  def update_reaction
    broadcast_update_to :update_reaction, target: "video-like-reaction-#{video.id}", html: video.reactions.likes.size

    broadcast_update_to :update_reaction, target: "video-dislike-reaction-#{video.id}", html: video.reactions.dislikes.size
  end
end
