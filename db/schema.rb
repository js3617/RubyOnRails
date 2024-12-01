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

ActiveRecord::Schema.define(version: 2024_12_01_033451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baskets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_baskets_on_course_id"
    t.index ["user_id"], name: "index_baskets_on_user_id"
  end

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

  create_table "payment_items", force: :cascade do |t|
    t.bigint "payment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_payment_items_on_course_id"
    t.index ["payment_id"], name: "index_payment_items_on_payment_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.string "transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "payment_method"
    t.string "pg_provider"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.text "review", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "rating"
    t.integer "parent_id"
    t.integer "likes_count", default: 0, null: false
    t.index ["course_id"], name: "index_reviews_on_course_id"
    t.index ["parent_id"], name: "index_reviews_on_parent_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "take_courses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "start_date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_take_courses_on_course_id"
    t.index ["user_id", "course_id"], name: "index_take_courses_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_take_courses_on_user_id"
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

  add_foreign_key "baskets", "courses"
  add_foreign_key "baskets", "users"
  add_foreign_key "class_lists", "courses"
  add_foreign_key "payment_items", "courses"
  add_foreign_key "payment_items", "payments"
  add_foreign_key "payments", "users"
  add_foreign_key "reviews", "courses"
  add_foreign_key "reviews", "users"
  add_foreign_key "take_courses", "courses"
  add_foreign_key "take_courses", "users"
end
