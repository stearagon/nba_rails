# == Schema Information
#
# Table name: shot_charts
#
#  id           :integer          not null, primary key
#  game_id      :string           not null
#  grid_type    :string           not null
#  player_id    :string           not null
#  team_id      :string           not null
#  period       :integer          not null
#  minutes_left :integer          not null
#  seconds_left :integer          not null
#  event_type   :string           not null
#  action_type  :string           not null
#  shot_type    :string           not null
#  zone_basic   :string           not null
#  zone_area    :string           not null
#  zone_range   :string           not null
#  distance     :integer          not null
#  location_x   :integer          not null
#  location_y   :integer          not null
#  made_shot?   :integer          not null
#

class ShotChart < ActiveRecord::Base
  belongs_to :team, class_name: 'Team', foreign_key: :team_id, primary_key: :nba_id
  belongs_to :player, class_name: 'Player', foreign_key: :player_id, primary_key: :nba_id
  belongs_to :game, class_name: 'Game', foreign_key: :game_id, primary_key: :nba_id
end
