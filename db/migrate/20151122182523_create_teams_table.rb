class CreateTeamsTable < ActiveRecord::Migration
  def change
    create_table :teams  do |t|
      t.string  :nba_id, null: false
      t.string  :mascot, null: false
      t.string  :abbreviation, null: false
      t.string  :conference, null: false
      t.string  :division, null: false

      t.timestamps
    end

    add_index :teams, :nba_id
  end
end
