# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :notificationable, polymorphic: true
  belongs_to :user
end
