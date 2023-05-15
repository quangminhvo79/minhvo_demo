# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_15_034634) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notifications", force: :cascade do |t|
    t.string "message"
    t.bigint "user_id"
    t.string "notificationable_type"
    t.bigint "notificationable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notificationable_type", "notificationable_id"], name: "index_notifications_on_notificationable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "video_reactions", force: :cascade do |t|
    t.string "kind", null: false
    t.bigint "video_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_video_reactions_on_user_id"
    t.index ["video_id"], name: "index_video_reactions_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "channel_name"
    t.string "title", null: false
    t.text "description"
    t.jsonb "thumbnails"
    t.string "youtube_video_id", null: false
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_videos_on_creator_id"
    t.index ["youtube_video_id", "creator_id"], name: "index_videos_on_youtube_video_id_and_creator_id", unique: true
  end

end
