# frozen_string_literal: true

class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    load_videos
  end

  def new
    @video = Video.find_by(id: params[:video_id])
  end

  def create
    service = Youtube::VideoCreator.new(youtube_url: youtube_url, user: current_user)

    if service.perform
      load_videos

      flash[:notice] = "Share Youtube video successfully"
      render :index
    else
      flash[:error] = service.errors.full_messages.join(". ")
      render :new
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
