class CreatePlayersTable < ActiveRecord::Migration
  def change
    create_table :players  do |t|
      t.string  :nba_id, null: false
      t.string  :first_name, null: false
      t.string  :last_name, null: false
      t.integer :rookie_year, null: false
      t.integer :final_year

      t.timestamps
    end

    add_index :players, :nba_id
  end
end
