# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Validations

  def expose_errors(message = nil)
    errors.add(service_name, message.to_s)

    false
  end

  private

  def service_name
    self.class.name.parameterize
  end
end
