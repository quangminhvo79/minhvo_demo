# frozen_string_literal: true

class VideosController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    load_videos
  end

  def new; end

  def show
    @video = Video.find(params[:id])
  end

  def create
    service = Youtube::VideoCreator.new(youtube_url: youtube_url, user: current_user)

    if service.perform
      load_videos

      flash.now[:notice] = 'Share Youtube video successfully'
      render :create, status: :ok
    else
      flash.now[:error] = service.error_sentence
      render :create, status: :bad_request
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
