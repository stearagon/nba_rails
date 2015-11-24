class AddQuartersColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :quarters, :integer
  end
end
