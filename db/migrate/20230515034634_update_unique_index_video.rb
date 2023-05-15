class UpdateUniqueIndexVideo < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, [:youtube_video_id, :creator_id], unique: true
  end
end
