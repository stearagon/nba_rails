# == Schema Information
#
# Table name: plays
#
#  id                    :integer          not null, primary key
#  game_id               :string           not null
#  event_num             :integer          not null
#  event_msg_type        :integer          not null
#  event_msg_action_type :integer          not null
#  period                :integer          not null
#  time                  :string           not null
#  play_clock_time       :string           not null
#  home_description      :string
#  neutral_description   :string
#  visitor_description   :string
#  score                 :integer
#  score_margin          :integer
#  player_1_type         :integer
#  player_1_id           :integer
#  player_1_team_id      :integer
#  player_2_type         :integer
#  player_2_id           :integer
#  player_2_team_id      :integer
#  player_3_type         :integer
#  player_3_id           :integer
#  player_3_team_id      :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  home_lineup_id        :string
#  away_lineup_id        :string
#

class Play < ActiveRecord::Base
  has_one :home_lineup, class_name: 'Lineup', primary_key: :home_lineup_id, foreign_key: :id
  has_one :away_lineup, class_name: 'Lineup', primary_key: :away_lineup_id, foreign_key: :id

  def play_time_in_secs
    play_clock_array = play_clock_time.split(":")

    if play_clock_time == "12:00"
      play_clock_minute = 11
      play_clock_seconds = 60
    else
      play_clock_minute = play_clock_array[0].to_i
      play_clock_seconds = play_clock_array[1].to_i
    end

    time = 0
    time += (period - 1) * 12 * 60
    time += (12 - 1 - play_clock_minute) * 60 + (60 - play_clock_seconds)
  end
end
