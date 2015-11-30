# == Schema Information
#
# Table name: teams
#
#  id           :integer          not null, primary key
#  nba_team_id  :integer          not null
#  season       :string           not null
#  city         :string           not null
#  mascot       :string           not null
#  abbreviation :string           not null
#  conference   :string           not null
#  division     :string           not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Team < ActiveRecord::Base
  has_many :home_games, class_name: 'Game', foreign_key: :home_team_id, primary_key: :nba_team_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_team_id, primary_key: :nba_team_id
  has_many :players, class_name: 'Player', foreign_key: :nba_team_id, primary_key: :nba_team_id
  has_many :stat_lines, class_name: 'StatLine', foreign_key: :nba_team_id, primary_key: :nba_team_id
end
