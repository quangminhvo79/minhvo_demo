# frozen_string_literal: true

class NotificationListComponent < ApplicationComponent
  def initialize(user: nil)
    @user = user.presence || Current.current_user
  end

  def notifications
    Notification.where(user: @user)
  end
end
