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

ActiveRecord::Schema.define(version: 20161005035657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advanced_stat_lines", force: :cascade do |t|
    t.string   "game_id",                         null: false
    t.string   "team_id",                         null: false
    t.string   "player_id",                       null: false
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
    t.index ["game_id", "team_id", "player_id"], name: "advanced_stat_line_index", unique: true, using: :btree
  end

  create_table "charts", force: :cascade do |t|
    t.string   "data",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charts_dashboards", id: false, force: :cascade do |t|
    t.integer  "chart_id",     null: false
    t.integer  "dashboard_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "season",     null: false
    t.string   "name",       null: false
    t.string   "team_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboards_users", id: false, force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "dashboard_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "game_referees", force: :cascade do |t|
    t.string   "game_id",    null: false
    t.integer  "referee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["game_id", "referee_id"], name: "index_game_referees_on_game_id_and_referee_id", unique: true, using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.string   "nba_id",                         null: false
    t.datetime "date",                           null: false
    t.boolean  "completed?",                     null: false
    t.boolean  "overtime?",                      null: false
    t.boolean  "national_game?",                 null: false
    t.boolean  "TNT?",                           null: false
    t.string   "away_team_id",                   null: false
    t.string   "home_team_id",                   null: false
    t.integer  "quarters",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "redo_lineups",   default: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
    t.index ["date"], name: "index_games_on_date", using: :btree
    t.index ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
    t.index ["nba_id"], name: "index_games_on_nba_id", using: :btree
  end

  create_table "lineups", force: :cascade do |t|
    t.string   "player_1_id", null: false
    t.string   "player_2_id", null: false
    t.string   "player_3_id", null: false
    t.string   "player_4_id", null: false
    t.string   "player_5_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["player_1_id", "player_2_id", "player_3_id", "player_4_id", "player_5_id"], name: "unique_lineups", unique: true, using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "nba_id",      null: false
    t.string   "first_name",  null: false
    t.string   "last_name",   null: false
    t.integer  "rookie_year", null: false
    t.integer  "final_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nba_id"], name: "index_players_on_nba_id", using: :btree
  end

  create_table "plays", force: :cascade do |t|
    t.string   "game_id",               null: false
    t.integer  "event_num",             null: false
    t.integer  "event_msg_type",        null: false
    t.integer  "event_msg_action_type", null: false
    t.integer  "period",                null: false
    t.string   "time",                  null: false
    t.string   "play_clock_time",       null: false
    t.string   "home_description"
    t.string   "neutral_description"
    t.string   "visitor_description"
    t.integer  "score"
    t.integer  "score_margin"
    t.integer  "player_1_type"
    t.integer  "player_1_id"
    t.integer  "player_1_team_id"
    t.integer  "player_2_type"
    t.integer  "player_2_id"
    t.integer  "player_2_team_id"
    t.integer  "player_3_type"
    t.integer  "player_3_id"
    t.integer  "player_3_team_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "home_lineup_id"
    t.string   "away_lineup_id"
    t.index ["game_id", "period"], name: "index_plays_on_game_id_and_period", using: :btree
    t.index ["game_id", "player_1_team_id"], name: "index_plays_on_game_id_and_player_1_team_id", using: :btree
    t.index ["game_id"], name: "index_plays_on_game_id", using: :btree
  end

  create_table "referees", force: :cascade do |t|
    t.string   "nba_id",        null: false
    t.string   "first_name",    null: false
    t.string   "last_name",     null: false
    t.integer  "jersey_number", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nba_id"], name: "index_referees_on_nba_id", unique: true, using: :btree
  end

  create_table "shot_charts", force: :cascade do |t|
    t.string  "game_id",      null: false
    t.string  "grid_type",    null: false
    t.string  "player_id",    null: false
    t.string  "team_id",      null: false
    t.integer "period",       null: false
    t.integer "minutes_left", null: false
    t.integer "seconds_left", null: false
    t.string  "event_type",   null: false
    t.string  "action_type",  null: false
    t.string  "shot_type",    null: false
    t.string  "zone_basic",   null: false
    t.string  "zone_area",    null: false
    t.string  "zone_range",   null: false
    t.integer "distance",     null: false
    t.integer "location_x",   null: false
    t.integer "location_y",   null: false
    t.integer "made_shot?",   null: false
    t.index ["game_id"], name: "index_shot_charts_on_game_id", using: :btree
    t.index ["minutes_left", "period", "seconds_left"], name: "shot_chart_data_index", using: :btree
    t.index ["player_id"], name: "index_shot_charts_on_player_id", using: :btree
    t.index ["team_id"], name: "index_shot_charts_on_team_id", using: :btree
  end

  create_table "stat_lines", force: :cascade do |t|
    t.string   "game_id",        null: false
    t.string   "team_id",        null: false
    t.string   "player_id",      null: false
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
    t.index ["game_id", "team_id", "player_id"], name: "stat_line_index", unique: true, using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "nba_id",       null: false
    t.string   "mascot",       null: false
    t.string   "abbreviation", null: false
    t.string   "conference",   null: false
    t.string   "division",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nba_id"], name: "index_teams_on_nba_id", using: :btree
  end

  create_table "tracking_stat_lines", force: :cascade do |t|
    t.string   "game_id"
    t.string   "team_id"
    t.string   "player_id"
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
    t.index ["game_id", "team_id", "player_id"], name: "tracking_stat_line_index", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token",                null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "default_dashboard_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
