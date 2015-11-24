# == Schema Information
#
# Table name: referees
#
#  id             :integer          not null, primary key
#  nba_referee_id :integer          not null
#  first_name     :string           not null
#  last_name      :string           not null
#  jersey_number  :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Referee < ActiveRecord::Base
  has_many :game_referees, class_name: 'GameReferee', foreign_key: :referee_id, primary_key: :nba_referee_id
  has_many :games, through: :game_referees, source: :game
end
