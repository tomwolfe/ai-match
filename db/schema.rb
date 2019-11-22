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

ActiveRecord::Schema.define(version: 2019_11_21_234424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_conversations_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_conversations_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "conversation_id"
    t.integer "user_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["read"], name: "index_messages_on_read"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "predictions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "predictor_id", null: false
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["predictor_id"], name: "index_predictions_on_predictor_id"
    t.index ["user_id", "predictor_id"], name: "index_predictions_on_user_id_and_predictor_id", unique: true
    t.index ["user_id"], name: "index_predictions_on_user_id"
    t.index ["value"], name: "index_predictions_on_value"
  end

  create_table "rates", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "rater_id"
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rater_id"], name: "index_rates_on_rater_id"
    t.index ["user_id", "rater_id"], name: "index_rates_on_user_id_and_rater_id", unique: true
    t.index ["user_id"], name: "index_rates_on_user_id"
    t.index ["value"], name: "index_rates_on_value"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.integer "age"
    t.integer "height"
    t.integer "weight"
    t.string "orientation"
    t.datetime "last_seen_at"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.string "sex"
    t.string "location"
    t.string "twitter"
    t.string "email"
    t.string "about"
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
  end

  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
end
