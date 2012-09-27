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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110805124026) do

  create_table "blogs", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "faqs", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.text     "bio"
    t.text     "faehigkeiten"
    t.text     "schulen"
    t.text     "firmen"
    t.text     "musik"
    t.text     "filme"
    t.text     "tv"
    t.text     "magazine"
    t.text     "buecher"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specs", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.string   "vorname",      :default => ""
    t.string   "nachname",     :default => ""
    t.string   "geschlecht"
    t.date     "geburtstag"
    t.string   "arbeit",       :default => ""
    t.string   "stadt",        :default => ""
    t.string   "land",         :default => ""
    t.string   "postleitzahl", :default => ""
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "screen_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "authorization_token"
  end

end
