# frozen_string_literal: true

class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    load_videos
  end

  def new; end

  def create
    service = Youtube::VideoCreator.new(youtube_url: youtube_url, user: current_user)

    if service.perform
      load_videos

      flash[:notice] = "Share Youtube video successfully"
    else
      flash[:error] = service.errors.full_messages.join(". ")
    end
  end

  private

  def load_videos
    @videos = Video.order(created_at: :desc)
  end

  def youtube_url
    params.require(:video).fetch(:youtube_url, '')
  end
end