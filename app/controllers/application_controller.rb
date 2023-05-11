class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :assign_current_user

  private

  def assign_current_user
    Current.current_user = current_user
  end
end
