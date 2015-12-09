# == Schema Information
#
# Table name: tracking_stat_lines
#
#  id                                :integer          not null, primary key
#  nba_game_id                       :string
#  nba_team_id                       :integer
#  nba_player_id                     :integer
#  start_position                    :string
#  minutes                           :float
#  speed                             :float
#  distance                          :float
#  offensive_rebound_chance          :integer
#  defensive_rebound_chance          :integer
#  rebound_chance                    :integer
#  touches                           :integer
#  secondary_assists                 :integer
#  free_throw_assists                :integer
#  passes                            :integer
#  contested_field_goals_made        :integer
#  contested_field_goals_attemtped   :integer
#  uncontested_field_goals_made      :integer
#  uncontested_field_goals_attemtped :integer
#  defending_field_goals_made        :integer
#  defending_field_goals_attemtped   :integer
#  created_at                        :datetime
#  updated_at                        :datetime
#

class TrackingStatLine < ActiveRecord::Base
  belongs_to :team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :nba_team_id
  belongs_to :player, class_name: 'Player', foreign_key: :nba_player_id, primary_key: :nba_player_id
  belongs_to :game, class_name: 'Game', foreign_key: :nba_game_id, primary_key: :nba_game_id
end
