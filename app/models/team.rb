require 'active_record'
require_relative './game.rb'

class Team < ActiveRecord::Base
  has_many :home_games, class_name: 'Game', foreign_key: :home_team, primary_key: :nba_team_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_team, primary_key: :nba_team_id

  has_many :players, class_name: 'Player', foreign_key: :nba_team_id, primary_key: :nba_team_id
end
