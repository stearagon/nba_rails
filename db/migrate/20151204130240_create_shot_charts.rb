class CreateShotCharts < ActiveRecord::Migration
  def change
    create_table :shot_charts do |t|
      t.integer :nba_game_id, null: false
      t.string :nba_grid_type, null: false
      t.integer :nba_player_id, null: false
      t.integer :nba_team_id, null: false
      t.integer :period, null: false
      t.integer :minutes_left, null: false
      t.integer :seconds_left, null: false
      t.string :event_type, null: false
      t.string :action_type, null: false
      t.string :shot_type, null: false
      t.string :zone_basic, null: false
      t.string :zone_area, null: false
      t.string :zone_range, null: false
      t.integer :distance, null: false
      t.integer :location_x, null: false
      t.integer :location_y, null: false
      t.integer :made_shot?, null: false
    end

    add_index :shot_charts, :nba_game_id
    add_index :shot_charts, :nba_team_id
    add_index :shot_charts, :nba_player_id
    add_index :shot_charts, [:nba_player_id, :nba_game_id, :minutes_left,
      :period, :seconds_left], unique: true, name: 'shot_chart_data_index'
  end
end
