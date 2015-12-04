class TrackingStatLine < ActiveRecord::Base
  belongs_to :team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :nba_team_id
  belongs_to :player, class_name: 'Player', foreign_key: :nba_player_id, primary_key: :nba_player_id
  belongs_to :game, class_name: 'Game', foreign_key: :nba_game_id, primary_key: :nba_game_id
end
