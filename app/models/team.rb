# == Schema Information
#
# Table name: teams
#
#  id           :integer          not null, primary key
#  nba_id       :string           not null
#  mascot       :string           not null
#  abbreviation :string           not null
#  conference   :string           not null
#  division     :string           not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Team < ActiveRecord::Base
  has_many :home_games, class_name: 'Game', foreign_key: :home_team_id, primary_key: :nba_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_team_id, primary_key: :nba_id
  has_many :players, -> { distinct }, through: :stat_lines, source: :player
  has_many :stat_lines, class_name: 'StatLine', foreign_key: :nba_id, primary_key: :nba_id

  def games
    home_games +  away_games
  end
end
