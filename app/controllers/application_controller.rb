# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :assign_current_user

  private

  def assign_current_user
    Current.current_user = current_user
  end

  def not_found
    render :file => Rails.root.join('public/404.html'), layout: false, status: :not_found
  end

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
end
