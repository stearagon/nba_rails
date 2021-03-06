class CreateShotCharts < ActiveRecord::Migration
  def change
    create_table :shot_charts do |t|
      t.string :game_id, null: false
      t.string :grid_type, null: false
      t.string :player_id, null: false
      t.string :team_id, null: false
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

    add_index :shot_charts, :game_id
    add_index :shot_charts, :team_id
    add_index :shot_charts, :player_id
    add_index :shot_charts, [:minutes_left,
      :period, :seconds_left], name: 'shot_chart_data_index'
  end
end
