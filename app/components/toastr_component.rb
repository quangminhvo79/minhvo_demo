# frozen_string_literal: true

class ToastrComponent < ApplicationComponent
  attr_reader :flash

  def initialize(flash:)
    @flash = flash
  end

  def icon_url(type)
    return 'success.svg' if type.to_s == 'notice'

    'error.svg'
  end

  def alert_class(type)
    return 'alert-success' if type.to_s == 'notice'

    'alert-error'
  end
end
