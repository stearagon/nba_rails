class CreateStatLines < ActiveRecord::Migration
  def change
    create_table :stat_lines do |t|
      t.string  :game_id, null: false
      t.string  :team_id, null: false
      t.string  :player_id, null: false
      t.string  :start_position, null: false
      t.float   :minutes
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

    add_index :stat_lines, [:game_id, :team_id, :player_id],
      unique: true, name: 'stat_line_index'
  end
end
