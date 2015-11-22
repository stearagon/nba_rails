class Game < ActiveRecord::Base
  has_one :home_team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :home_team_id
  has_one :away_team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :away_team_id
end
