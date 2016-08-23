class CreateGamesTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string         :nba_id, null: false
      t.datetime       :date, null: false
      t.boolean        :completed?, null: false
      t.boolean        :overtime?, null: false
      t.boolean        :national_game?, null: false
      t.boolean        :TNT?, null: false
      t.string         :away_team_id, null: false
      t.string         :home_team_id, null: false
      t.integer        :quarters, null: false

      t.timestamps
    end

    add_index :games, :nba_id
    add_index :games, :date
    add_index :games, :home_team_id
    add_index :games, :away_team_id
  end
end
