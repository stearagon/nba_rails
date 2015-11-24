class CreateStatLines < ActiveRecord::Migration
  def change
    create_table :stat_lines do |t|
      t.string :nba_game_id, null: false
      t.integer :nba_team_id, null: false
      t.integer :nba_player_id, null: false
      t.string :start_position, null: false
      t.integer :minutes
      t.integer :fgm
      t.integer :fga
      t.integer :fg3m
      t.integer :fg3a
      t.integer :ftm
      t.integer :fta
      t.integer :oreb
      t.integer :dreb
      t.integer :ast
      t.integer :stl
      t.integer :blk
      t.integer :to
      t.integer :pf
      t.integer :plus_minus

      t.timestamps
    end

    add_index :stat_lines, [:nba_game_id, :nba_team_id, :nba_player_id],
      unique: true, name: 'stat_line_index'
  end
end
