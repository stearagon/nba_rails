class AddLineup < ActiveRecord::Migration[5.0]
  def change
    create_table :lineups  do |t|
      t.string :player_1_id, null: false
      t.string :player_2_id, null: false
      t.string :player_3_id, null: false
      t.string :player_4_id, null: false
      t.string :player_5_id, null: false

      t.timestamps
    end

    add_column :plays, :home_lineup_id, :string
    add_column :plays, :away_lineup_id, :string
    add_column :games, :redo_lineups, :boolean, default: false

    add_index :lineups, [
      :player_1_id,
      :player_2_id,
      :player_3_id,
      :player_4_id,
      :player_5_id
    ], 
    name: :unique_lineups,
    unique: true
  end
end
