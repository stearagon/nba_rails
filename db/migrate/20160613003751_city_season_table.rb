class CitySeasonTable < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :season, null: false
      t.string :name, null: false
      t.string :team_id, null: false

      t.timestamps
    end

  end
end
