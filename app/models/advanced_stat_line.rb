# == Schema Information
#
# Table name: advanced_stat_lines
#
#  id                              :integer          not null, primary key
#  game_id                         :string           not null
#  team_id                         :string           not null
#  player_id                       :string           not null
#  start_position                  :string           not null
#  minutes                         :float
#  offensive_rating                :float
#  defensive_rating                :float
#  assist_percentage               :float
#  assist_to_turnover              :float
#  assist_ratio                    :float
#  offensive_rebound_percentage    :float
#  defensive_rebound_percentage    :float
#  rebound_percentage              :float
#  team_turnover_percentage        :float
#  effective_field_goal_percentage :float
#  true_shooting_percentage        :float
#  usage_percentage                :float
#  pace                            :float
#  pie                             :float
#  created_at                      :datetime
#  updated_at                      :datetime
#

class AdvancedStatLine < ActiveRecord::Base
  belongs_to :team, class_name: 'Team', foreign_key: :team_id, primary_key: :nba_id
  belongs_to :player, class_name: 'Player', foreign_key: :player_id, primary_key: :player_id
  belongs_to :game, class_name: 'Game', foreign_key: :game_id, primary_key: :nba_id
end
