require 'active_record'
require_relative './team.rb'

class Game < ActiveRecord::Base
  has_one :home_team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :home_team
  has_one :away_team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :away_team
end
