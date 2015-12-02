class CreateAdvancedStatLines < ActiveRecord::Migration
  def change
    create_table :advanced_stat_lines do |t|
      t.string :nba_game_id, null: false
      t.integer :nba_team_id, null: false
      t.integer :nba_player_id, null: false
      t.string :start_position, null: false
      t.integer :minutes
      t.float :offensive_rating
      t.float :defensive_rating
      t.float :assist_percentage
      t.float :assist_to_turnover
      t.float :assist_ratio
      t.float :offensive_rebound_percentage
      t.float :defensive_rebound_percentage
      t.float :rebound_percentage
      t.float :team_turnover_percentage
      t.float :effective_field_goal_percentage
      t.float :true_shooting_percentage
      t.float :usage_percentage
      t.float :pace
      t.float :pie

      t.timestamps
    end

    add_index :advanced_stat_lines, [:nba_game_id, :nba_team_id, :nba_player_id],
      unique: true, name: 'advanced_stat_line_index'
  end
end
