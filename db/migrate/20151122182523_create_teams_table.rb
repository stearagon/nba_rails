class CreateTeamsTable < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :nba_team_id, null: false
      t.string :season, null: false
      t.string :city, null: false
      t.string :mascot, null: false
      t.string :abbreviation, null: false
      t.string :conference, null: false
      t.string :division, null: false

      t.timestamps
    end

    add_index :teams, :nba_team_id, unique: true
  end
end
