module NBAApi
  class PlayByPlayGrab
    attr_reader :game_id, :season_type, :game, :season

    def initialize(game_id, season_type)
      @game_id = game_id
      @season_type = season_type
    end

    def get_plays
      play_by_play_json = HTTP.get(link_builder(game.nba_game_id)).parse

      play_by_play_json['resultSets'][0]['rowSet'].each do |play|
        play_data = grab_specific_play_data(play)
        new_play = Play.find_by(game_id: play_data[:nba_game_id], event_num: play_data[:event_num])

        if new_play
            new_play.update(play_data)
        else
          Play.create(play_data)
        end
      end

      return "Done"
    end

    def season
      @season ||= ::Helpers::SeasonHelper.season_finder(game.date)
    end

    def game
      @game ||= Game.find_by_nba_id(game_id)
    end

    def link_builder
      link = 'http://stats.nba.com/stats/playbyplayv2?EndPeriod=10&EndRange='
      link += game.quarters == 4 ? '28800' : ((game.quarters.to_i - 4 * 3000) + 28800).to_s
      link += '&GameID='
      link += game_id
      link += '&RangeType=0&Season='
      link += season
      link += '&SeasonType='
      link += @season_type
      link += '&StartPeriod=1&StartRange=0'

      link
    end

    def grab_specific_play_data(play)
      play_data = {}

      play_data[:game_id] = stats[0]
      play_data[:event_num] = stats[1]
      play_data[:event_msg_type] = stats[2]
      play_data[:event_msg_action_type] = stats[3]
      play_data[:period] = stats[4]
      play_data[:time] = stats[5]
      play_data[:play_clock_time] = stats[6]
      play_data[:home_description] = stats[7]
      play_data[:neutral_description] = stats[8]
      play_data[:visitor_description] = stats[9]
      play_data[:score] = stats[10]
      play_data[:score_margin] = stats[11]
      play_data[:person_1_type] = stats[12]
      play_data[:player_1_id] = stats[13]
      play_data[:player_1_team_id] = stats[15]
      play_data[:person_2_type] = stats[19]
      play_data[:person_2_id] = stats[20]
      play_data[:person_2_team_id] = stats[22]
      play_data[:person_3_type] = stats[26]
      play_data[:person_3_id] = stats[27]
      play_data[:person_3_team_id] = stats[29]

      play_data
    end
  end
end
