# frozen_string_literal: true

class ReactionsController < ApplicationController
  def like
    video.create_reaction(kind: :like, user: current_user)
  end

  def dislike
    video.create_reaction(kind: :dislike, user: current_user)
  end

  def destroy
    video.reactions.find_by(user: current_user).destroy
  end

  private

  def video
    @video ||= Video.find_by(id: params[:video_id])
  end
end
