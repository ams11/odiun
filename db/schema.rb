# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140722032914) do

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "genres", force: true do |t|
    t.string "name"
  end

  create_table "ranks", force: true do |t|
    t.integer "rank",                                        null: false
    t.decimal "videos_watched",     precision: 10, scale: 4, null: false
    t.decimal "original_selection", precision: 10, scale: 4, null: false
    t.decimal "personal_content",   precision: 10, scale: 4, null: false
    t.string  "name"
  end

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  create_table "user_genre_scores", force: true do |t|
    t.integer "user_id",                                            null: false
    t.integer "genre_id",                                           null: false
    t.decimal "score",       precision: 10, scale: 4, default: 0.0
    t.string  "score_type",                                         null: false
    t.integer "video_count"
  end

  create_table "user_votes", force: true do |t|
    t.integer "user_id"
    t.integer "video_id"
    t.integer "score_emotion"
    t.integer "score_intellect"
    t.integer "score_entertain"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "rank_id"
    t.integer  "genre_id"
    t.integer  "videos_watched_count"
    t.integer  "user_genre_score_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "unique_id"
    t.boolean  "visible",             default: false
    t.string   "thumbnail_url"
    t.integer  "user_id"
    t.boolean  "featured",            default: false
    t.string   "large_thumbnail_url"
    t.integer  "genre_id"
    t.integer  "score_total",         default: 0
    t.integer  "max_score",           default: 0
    t.boolean  "approved",            default: false
  end

end
