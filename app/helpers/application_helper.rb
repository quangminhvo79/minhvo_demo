# frozen_string_literal: true

module ApplicationHelper
  def show_toastr
    turbo_stream.update(:notifications) { render(ToastrComponent.new(flash: flash)) }
  end
end
