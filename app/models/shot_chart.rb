# == Schema Information
#
# Table name: shot_charts
#
#  id            :integer          not null, primary key
#  nba_game_id   :integer          not null
#  nba_grid_type :string           not null
#  nba_player_id :integer          not null
#  nba_team_id   :integer          not null
#  period        :float            not null
#  minutes_left  :float            not null
#  seconds_left  :float            not null
#  event_type    :string           not null
#  action_type   :string           not null
#  shot_type     :string           not null
#  zone_basic    :string           not null
#  zone_area     :string           not null
#  zone_range    :string           not null
#  distance      :float            not null
#  location_x    :float            not null
#  location_y    :float            not null
#  made_shot?    :float            not null
#

class ShotChart < ActiveRecord::Base
end
