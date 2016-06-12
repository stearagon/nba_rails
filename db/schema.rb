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

ActiveRecord::Schema.define(version: 20160612162311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advanced_stat_lines", force: :cascade do |t|
    t.string   "nba_game_id",                     null: false
    t.integer  "nba_team_id",                     null: false
    t.integer  "nba_player_id",                   null: false
    t.string   "start_position",                  null: false
    t.float    "minutes"
    t.float    "offensive_rating"
    t.float    "defensive_rating"
    t.float    "assist_percentage"
    t.float    "assist_to_turnover"
    t.float    "assist_ratio"
    t.float    "offensive_rebound_percentage"
    t.float    "defensive_rebound_percentage"
    t.float    "rebound_percentage"
    t.float    "team_turnover_percentage"
    t.float    "effective_field_goal_percentage"
    t.float    "true_shooting_percentage"
    t.float    "usage_percentage"
    t.float    "pace"
    t.float    "pie"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "advanced_stat_lines", ["nba_game_id", "nba_team_id", "nba_player_id"], name: "advanced_stat_line_index", unique: true, using: :btree

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

  create_table "shot_charts", force: :cascade do |t|
    t.integer "nba_game_id",   null: false
    t.string  "nba_grid_type", null: false
    t.integer "nba_player_id", null: false
    t.integer "nba_team_id",   null: false
    t.float   "period",        null: false
    t.float   "minutes_left",  null: false
    t.float   "seconds_left",  null: false
    t.string  "event_type",    null: false
    t.string  "action_type",   null: false
    t.string  "shot_type",     null: false
    t.string  "zone_basic",    null: false
    t.string  "zone_area",     null: false
    t.string  "zone_range",    null: false
    t.float   "distance",      null: false
    t.float   "location_x",    null: false
    t.float   "location_y",    null: false
    t.float   "made_shot?",    null: false
  end

  add_index "shot_charts", ["nba_game_id"], name: "index_shot_charts_on_nba_game_id", using: :btree
  add_index "shot_charts", ["nba_player_id", "nba_game_id", "minutes_left", "period", "seconds_left"], name: "shot_chart_data_index", unique: true, using: :btree
  add_index "shot_charts", ["nba_player_id"], name: "index_shot_charts_on_nba_player_id", using: :btree
  add_index "shot_charts", ["nba_team_id"], name: "index_shot_charts_on_nba_team_id", using: :btree

  create_table "stat_lines", force: :cascade do |t|
    t.string   "nba_game_id",    null: false
    t.integer  "nba_team_id",    null: false
    t.integer  "nba_player_id",  null: false
    t.string   "start_position", null: false
    t.float    "minutes"
    t.integer  "fgm"
    t.integer  "fga"
    t.integer  "fg3m"
    t.integer  "fg3a"
    t.integer  "ftm"
    t.integer  "fta"
    t.integer  "oreb"
    t.integer  "dreb"
    t.integer  "ast"
    t.integer  "stl"
    t.integer  "blk"
    t.integer  "to"
    t.integer  "pf"
    t.integer  "plus_minus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stat_lines", ["nba_game_id", "nba_team_id", "nba_player_id"], name: "stat_line_index", unique: true, using: :btree

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

  add_index "teams", ["nba_team_id", "city", "season"], name: "index_teams_on_nba_team_id_and_city_and_season", unique: true, using: :btree

  create_table "tracking_stat_lines", force: :cascade do |t|
    t.string   "nba_game_id"
    t.integer  "nba_team_id"
    t.integer  "nba_player_id"
    t.string   "start_position"
    t.float    "minutes"
    t.float    "speed"
    t.float    "distance"
    t.integer  "offensive_rebound_chance"
    t.integer  "defensive_rebound_chance"
    t.integer  "rebound_chance"
    t.integer  "touches"
    t.integer  "secondary_assists"
    t.integer  "free_throw_assists"
    t.integer  "passes"
    t.integer  "contested_field_goals_made"
    t.integer  "contested_field_goals_attemtped"
    t.integer  "uncontested_field_goals_made"
    t.integer  "uncontested_field_goals_attemtped"
    t.integer  "defending_field_goals_made"
    t.integer  "defending_field_goals_attemtped"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracking_stat_lines", ["nba_game_id", "nba_team_id", "nba_player_id"], name: "tracking_stat_line_index", unique: true, using: :btree

end
