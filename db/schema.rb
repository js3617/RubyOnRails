# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_11_24_144151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "class_lists", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "lesson_name", null: false
    t.text "description"
    t.string "youtube_video_id", null: false
    t.string "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thumbnail_url"
    t.index ["course_id"], name: "index_class_lists_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "class_name", null: false
    t.text "description"
    t.string "youtube_playlist_id", null: false
    t.integer "price", default: 0
    t.integer "rating", default: 0
    t.integer "like", default: 0
    t.string "level", default: "초급"
    t.boolean "certificate", default: false
    t.integer "sessions_count", default: 0
    t.string "provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thumbnail_url"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "class_lists", "courses"
end
