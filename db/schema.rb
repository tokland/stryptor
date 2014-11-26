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

ActiveRecord::Schema.define(version: 20141126201555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "strip_collections", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "footer"
    t.string   "image_url"
    t.string   "icon_url"
  end

  create_table "strips", force: true do |t|
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "code"
    t.date     "publised_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "strip_collection_id"
    t.integer  "transcripts_count",   default: 0
    t.text     "text"
  end

  create_table "transcripts", force: true do |t|
    t.integer  "strip_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transcripts", ["strip_id"], name: "index_transcripts_on_strip_id", using: :btree
  add_index "transcripts", ["user_id"], name: "index_transcripts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string "name"
    t.string "email"
    t.string "provider"
    t.string "uid"
  end

end
