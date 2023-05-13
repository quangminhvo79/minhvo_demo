# frozen_string_literal: true

class Video < ApplicationRecord
  attr_accessor :youtube_url

  belongs_to :creator, class_name: 'User'
  has_many :reactions, class_name: 'VideoReaction', dependent: :destroy
  has_many :notifications, as: :notificationable, dependent: :destroy

  validates :title, presence: true
  validates :youtube_video_id, presence: { message: "can't be blank or wrong video link" },
                               uniqueness: { scope: :creator_id, message: "cannot share twice" }

  after_create_commit :send_notification

  def create_reaction(kind:, user:)
    reaction = reactions.where(user: user).first_or_initialize
    reaction.update(kind: kind)
  end

  private

  def message
    I18n.t('video_notification_messages', user_email: creator.email,
                                          title: title,
                                          youtube_video_id: youtube_video_id)
  end

  def send_notification
    User.where.not(id: creator.id).each do |user|
      Notification.create(message: message, user: user, notificationable: self)
      broadcast_append_to(user, :videos, target: "notifications",
                                         partial: 'notifications/new',
                                         locals: { message: { notice: message.html_safe }, user: user })
    end
  end
end
