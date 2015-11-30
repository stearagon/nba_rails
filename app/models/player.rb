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
  belongs_to :team, class_name: 'Team', foreign_key: :nba_team_id, primary_key: :nba_team_id

  has_many :stat_lines, class_name: 'StatLine', foreign_key: :nba_player_id, primary_key: :nba_player_id
end
