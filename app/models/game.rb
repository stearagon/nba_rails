# == Schema Information
#
# Table name: games
#
#  id             :integer          not null, primary key
#  nba_game_id    :string           not null
#  date           :datetime         not null
#  completed?     :boolean          not null
#  overtime?      :boolean          not null
#  national_game? :boolean          not null
#  TNT?           :boolean          not null
#  away_team_id   :integer          not null
#  home_team_id   :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#  quarters       :integer
#

class Game < ActiveRecord::Base
  has_one :home_team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :home_team_id
  has_one :away_team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :away_team_id

  has_many :game_referees, class_name: 'GameReferee', foreign_key: :game_id, primary_key: :nba_game_id
  has_many :referees, through: :game_referees, source: :referee

  has_many :stat_lines, class_name: 'StatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id

  has_many :played_stat_lines, -> (object){ where("minutes > ?", 0)}, class_name: 'StatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id
  has_many :played_players, through: :played_stat_lines, source: :player

  has_many :stat_lines, class_name: 'StatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id
  has_many :dressed_players, through: :stat_lines, source: :player
end
