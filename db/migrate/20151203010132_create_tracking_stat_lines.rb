class CreateTrackingStatLines < ActiveRecord::Migration
  def change
    create_table :tracking_stat_lines do |t|
      t.string :nba_game_id
      t.integer :nba_team_id
      t.integer :nba_player_id
      t.string :start_position
      t.float :minutes
      t.float :speed
      t.float :distance
      t.integer :offensive_rebound_chance
      t.integer :defensive_rebound_chance
      t.integer :rebound_chance
      t.integer :touches
      t.integer :secondary_assists
      t.integer :free_throw_assists
      t.integer :passes
      t.integer :contested_field_goals_made
      t.integer :contested_field_goals_attemtped
      t.integer :uncontested_field_goals_made
      t.integer :uncontested_field_goals_attemtped
      t.integer :defending_field_goals_made
      t.integer :defending_field_goals_attemtped

      t.timestamps
    end

    add_index :tracking_stat_lines, [:nba_game_id, :nba_team_id, :nba_player_id],
      unique: true, name: 'tracking_stat_line_index'
  end
end
