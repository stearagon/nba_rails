class CreateGamesTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string          :nba_game_id, null: false
      t.datetime        :date, null: false
      t.boolean         :completed?, null: false
      t.boolean         :overtime?, null: false
      t.boolean         :national_game?, null: false
      t.boolean         :TNT?, null: false
      t.integer         :away_team, null: false
      t.integer         :home_team, null: false

      t.timestamps
    end

    add_index :games, :date
    add_index :games, :nba_game_id, unique: true
    add_index :games, :home_team
    add_index :games, :away_team
  end
end
