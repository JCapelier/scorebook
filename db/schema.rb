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

ActiveRecord::Schema[8.0].define(version: 2025_07_17_131718) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "game_sessions", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "place"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_sessions_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "moves", force: :cascade do |t|
    t.bigint "session_player_id", null: false
    t.bigint "round_id", null: false
    t.string "move_type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_moves_on_round_id"
    t.index ["session_player_id"], name: "index_moves_on_session_player_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "score_sheet_id", null: false
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["score_sheet_id"], name: "index_rounds_on_score_sheet_id"
  end

  create_table "score_sheets", force: :cascade do |t|
    t.bigint "game_session_id", null: false
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_score_sheets_on_game_session_id"
  end

  create_table "session_players", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_session_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_session_players_on_game_session_id"
    t.index ["user_id"], name: "index_session_players_on_user_id"
  end

  create_table "user_stats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "games_played", default: 0, null: false
    t.integer "games_won", default: 0, null: false
    t.integer "highest_round_score", default: 0, null: false
    t.integer "longest_zero_streak", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id", null: false
    t.index ["game_id"], name: "index_user_stats_on_game_id"
    t.index ["user_id", "game_id"], name: "index_user_stats_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_user_stats_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "game_sessions", "games"
  add_foreign_key "moves", "rounds"
  add_foreign_key "moves", "session_players"
  add_foreign_key "rounds", "score_sheets"
  add_foreign_key "score_sheets", "game_sessions"
  add_foreign_key "session_players", "game_sessions"
  add_foreign_key "session_players", "users"
  add_foreign_key "user_stats", "games"
  add_foreign_key "user_stats", "users"
end
