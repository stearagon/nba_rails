module NBAApi
  class PlayByPlayGrab
    attr_reader :game_id, :season_type, :game, :season

    def initialize(game_id, season_type)
      @game_id = game_id
      @season_type = season_type
    end

    def get_plays
      play_by_play_json = HTTP.get(link_builder).parse

      play_by_play_json['resultSets'][0]['rowSet'].each do |play|
        play_data = grab_specific_play_data(play)
        new_play = ::Play.find_by(game_id: play_data[:game_id], event_num: play_data[:event_num])

        if new_play
            new_play.update(play_data)
        else
          ::Play.create(play_data)
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

      play_data[:game_id] = play[0]
      play_data[:event_num] = play[1]
      play_data[:event_msg_type] = play[2]
      play_data[:event_msg_action_type] = play[3]
      play_data[:period] = play[4]
      play_data[:time] = play[5]
      play_data[:play_clock_time] = play[6]
      play_data[:home_description] = play[7]
      play_data[:neutral_description] = play[8]
      play_data[:visitor_description] = play[9]
      play_data[:score] = play[10]
      play_data[:score_margin] = play[11]
      play_data[:player_1_type] = play[12]
      play_data[:player_1_id] = play[13]
      play_data[:player_1_team_id] = play[15]
      play_data[:player_2_type] = play[19]
      play_data[:player_2_id] = play[20]
      play_data[:player_2_team_id] = play[22]
      play_data[:player_3_type] = play[26]
      play_data[:player_3_id] = play[27]
      play_data[:player_3_team_id] = play[29]

      play_data
    end
  end
end
