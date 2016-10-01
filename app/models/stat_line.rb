# == Schema Information
#
# Table name: stat_lines
#
#  id             :integer          not null, primary key
#  game_id        :string           not null
#  team_id        :string           not null
#  player_id      :string           not null
#  start_position :string           not null
#  minutes        :float
#  fgm            :integer
#  fga            :integer
#  fg3m           :integer
#  fg3a           :integer
#  ftm            :integer
#  fta            :integer
#  oreb           :integer
#  dreb           :integer
#  ast            :integer
#  stl            :integer
#  blk            :integer
#  to             :integer
#  pf             :integer
#  plus_minus     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class StatLine < ActiveRecord::Base
  attr_reader :home_team_id
  belongs_to :team, class_name: 'Team', foreign_key: :team_id, primary_key: :nba_id
  belongs_to :player, class_name: 'Player', foreign_key: :player_id, primary_key: :nba_id
  belongs_to :game, class_name: 'Game', foreign_key: :game_id, primary_key: :nba_id
end
