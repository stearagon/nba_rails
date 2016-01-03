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
  has_many :tracking_stat_lines, class_name: 'TrackingStatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id
  has_many :advanced_stat_lines, class_name: 'AdvancedStatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id

  has_many :played_stat_lines, -> (object){ where("minutes > ?", 0)}, class_name: 'StatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id
  has_many :played_players, through: :played_stat_lines, source: :player

  has_many :stat_lines, class_name: 'StatLine', foreign_key: :nba_game_id, primary_key: :nba_game_id
  has_many :dressed_players, through: :stat_lines, source: :player

  def minutes
    if self[:quarters] > 4
      return ((self[:quarters] - 4) * 5) + 48
    end

    return 48
  end

  def rests
    rests = {}
    previous_home_game = home_team.games.select { |game| game.date < self.date }.max
    previous_away_game = away_team.games.select { |game| game.date < self.date }.max

    if !previous_home_game.nil?
      rests[:home_team] = ((self.date - previous_home_game.date) / 86400).to_i
    else
      rests[:home_team] = 5
    end

    if !previous_away_game.nil?
      rests[:away_team] = ((self.date - previous_away_game.date) / 86400).to_i
    else
      rests[:away_team] = 5
    end

    rests
  end

  def games_in_5_days
    games_in_5_days = {}
    games_in_5_days[:home_team] = home_team.games.select { |game| game.date < self.date  && game.date > (self.date - (86400 * 5)) }.length
    games_in_5_days[:away_team] = away_team.games.select { |game| game.date < self.date  && game.date > (self.date - (86400 * 5)) }.length

    games_in_5_days
  end

  def games_in_10_days
    games_in_10_days = {}
    games_in_10_days[:home_team] = home_team.games.select { |game| game.date < self.date  && game.date > (self.date - (86400 * 10)) }.length
    games_in_10_days[:away_team] = away_team.games.select { |game| game.date < self.date  && game.date > (self.date - (86400 * 10)) }.length

    games_in_10_days
  end
end
