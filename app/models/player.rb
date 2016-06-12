# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  nba_player_id :integer          not null
#  season        :string           not null
#  first_name    :string           not null
#  last_name     :string           not null
#  rookie_year   :integer          not null
#  final_year    :integer          not null
#  nba_team_id   :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Player < ActiveRecord::Base
  has_many(
    :stat_lines,
    class_name: 'StatLine',
    foreign_key: :nba_player_id,
    primary_key: :nba_player_id
  )

  has_many :teams,  -> { distinct }, through: :stat_lines, source: :team
  has_many :games, through: :stat_lines, source: :game

  has_many(
    :advanced_stat_lines,
    class_name: 'AdvancedStatLine',
    foreign_key: :nba_player_id,
    primary_key: :nba_player_id
  )

  has_many(
    :tracking_stat_lines,
    class_name: 'TrackingStatLine',
    foreign_key: :nba_player_id,
    primary_key: :nba_player_id
  )

  has_many(
    :shot_charts,
    class_name: 'ShotChart',
    foreign_key: :nba_player_id,
    primary_key: :nba_player_id
  )
end
