class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string          :channel_name
      t.string          :title, null: false
      t.text            :description
      t.jsonb           :thumbnails
      t.string          :youtube_video_id, null: false
      t.references      :creator

      t.timestamps
    end
  end
end
