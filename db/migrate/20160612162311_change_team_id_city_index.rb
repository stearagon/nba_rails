class ChangeTeamIdCityIndex < ActiveRecord::Migration
  def change
    remove_index :teams, [:nba_team_id, :city]
    add_index :teams, [:nba_team_id, :city, :season], unique: true
  end
end
