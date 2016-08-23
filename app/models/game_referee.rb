# == Schema Information
#
# Table name: game_referees
#
#  id         :integer          not null, primary key
#  game_id    :string           not null
#  referee_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class GameReferee < ActiveRecord::Base
  has_one :referee, class_name: 'Referee', foreign_key: :referee_id, primary_key: :nba_id
  has_one :game, class_name: 'Game', foreign_key: :game_id, primary_key: :nba_id
end
