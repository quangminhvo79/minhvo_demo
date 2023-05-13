# frozen_string_literal: true

class NotificationListComponent < ApplicationComponent
  def initialize(user: nil)
    @user = user.presence || Current.current_user
  end

  def notifications
    @notifications ||= @user.notifications.order(created_at: :desc)
  end

  def render?
    Current.current_user.present?
  end
end
