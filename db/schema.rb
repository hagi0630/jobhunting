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

ActiveRecord::Schema.define(version: 2022_07_24_094532) do

  create_table "companies", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "url"
    t.string "mypage_id"
    t.string "mypage_pwd"
    t.string "task1"
    t.datetime "due1"
    t.string "task2"
    t.datetime "due2"
    t.string "task3"
    t.datetime "due3"
    t.string "task4"
    t.datetime "due4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "users" because of following StandardError
#   Unknown type '' for column 'password_digest'

end
