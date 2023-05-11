class CreateVideoReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :video_reactions do |t|
      t.string :kind, null: false
      t.references :video
      t.references :user
      t.timestamps
    end
  end
end
