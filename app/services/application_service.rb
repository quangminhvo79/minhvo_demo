# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Validations

  def expose_errors(message = nil)
    errors.add(self.class.name.parameterize, message.to_s)

    false
  end

  def error_sentence
    errors.full_messages.to_sentence
  end

  private

  def copy_errors_from(errors_source)
    errors_source.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
  end
end
