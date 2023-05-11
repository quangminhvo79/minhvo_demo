# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  include ApplicationHelper

  delegate :current_user, to: Current
end
