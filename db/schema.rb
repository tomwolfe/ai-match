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

ActiveRecord::Schema.define(version: 20190825054945) do

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["receiver_id"], name: "index_conversations_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_conversations_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.boolean  "read",            default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["read"], name: "index_messages_on_read"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rater_id"
    t.boolean  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rater_id"], name: "index_rates_on_rater_id"
    t.index ["user_id", "rater_id"], name: "index_rates_on_user_id_and_rater_id", unique: true
    t.index ["user_id"], name: "index_rates_on_user_id"
    t.index ["value"], name: "index_rates_on_value"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.integer  "age"
    t.integer  "height"
    t.integer  "weight"
    t.string   "orientation"
    t.datetime "last_seen_at"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "picture"
    t.string   "sex"
    t.string   "location"
    t.string   "twitter"
    t.string   "email"
    t.string   "about"
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
  end

end
