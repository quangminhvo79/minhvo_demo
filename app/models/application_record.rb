# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def klass
    self.class.table_name.singularize
  end

  def query_selector
    "record_#{klass}_#{id}".camelize
  end
end
