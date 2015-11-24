class CreateReferees < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.integer :nba_referee_id, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :jersey_number, null: false

      t.timestamps
    end

    add_index :referees, :nba_referee_id, unique: true

    create_table :game_referees do |t|
      t.string :game_id, null: false
      t.integer :referee_id, null: false

      t.timestamps
    end

    add_index :game_referees, [:game_id, :referee_id], unique: true
  end
end
