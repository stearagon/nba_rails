class CreatePlayersTable < ActiveRecord::Migration
  def change
    create_table :players_tables do |t|
      t.integer :nba_player_id, null: false
      t.string :season, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :rookie_year, null: false
      t.integer :final_year, null: false
      t.integer :nba_team_id, null: false

      t.timestamps
    end

    add_index :players, :nba_player_id, unique: true
  end
end
