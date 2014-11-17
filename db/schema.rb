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

ActiveRecord::Schema.define(version: 20141116132931) do

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
  end

  create_table "transcripts", force: true do |t|
    t.integer  "script_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transcripts", ["script_id"], name: "index_transcripts_on_script_id"
  add_index "transcripts", ["user_id"], name: "index_transcripts_on_user_id"

  create_table "users", force: true do |t|
    t.string "name"
    t.string "email"
    t.string "provider"
    t.string "uid"
  end

end
