class RemoveTeamsIndexOnTeamId < ActiveRecord::Migration
  def change
    remove_index :teams, :nba_team_id
    add_index :teams, [:nba_team_id, :city], unique: true
  end
end
