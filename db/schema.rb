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

ActiveRecord::Schema.define(version: 20151124044355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_referees", force: :cascade do |t|
    t.string   "game_id",    null: false
    t.integer  "referee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_referees", ["game_id", "referee_id"], name: "index_game_referees_on_game_id_and_referee_id", unique: true, using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "nba_game_id",    null: false
    t.datetime "date",           null: false
    t.boolean  "completed?",     null: false
    t.boolean  "overtime?",      null: false
    t.boolean  "national_game?", null: false
    t.boolean  "TNT?",           null: false
    t.integer  "away_team_id",   null: false
    t.integer  "home_team_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quarters"
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["date"], name: "index_games_on_date", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
  add_index "games", ["nba_game_id"], name: "index_games_on_nba_game_id", unique: true, using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "nba_player_id", null: false
    t.string   "season",        null: false
    t.string   "first_name",    null: false
    t.string   "last_name",     null: false
    t.integer  "rookie_year",   null: false
    t.integer  "final_year",    null: false
    t.integer  "nba_team_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["nba_player_id"], name: "index_players_on_nba_player_id", unique: true, using: :btree

  create_table "referees", force: :cascade do |t|
    t.integer  "nba_referee_id", null: false
    t.string   "first_name",     null: false
    t.string   "last_name",      null: false
    t.integer  "jersey_number",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referees", ["nba_referee_id"], name: "index_referees_on_nba_referee_id", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "nba_team_id",  null: false
    t.string   "season",       null: false
    t.string   "city",         null: false
    t.string   "mascot",       null: false
    t.string   "abbreviation", null: false
    t.string   "conference",   null: false
    t.string   "division",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["nba_team_id"], name: "index_teams_on_nba_team_id", unique: true, using: :btree

end
