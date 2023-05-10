# frozen_string_literal: true

class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @videos = Video.order(created_at: :desc)
  end
end
