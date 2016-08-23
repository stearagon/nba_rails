module NBAApi
  class StatLineGrab
    def initialize(date, season, season_type)
      @date = date
      @season = season
      @season_type = season_type
    end

    def get_stat_lines
      games = Game.where(date: @date)

      if games.present?
        games.each do |game|
          stat_line_json = HTTP.get(link_builder(game.nba_id)).parse

          stat_line_json['resultSets'][0]['rowSet'].each do |stat_line|
            stat_data = grab_specific_stat_line_data(stat_line)
            new_stat_line = StatLine.find_by(game_id: stat_data[:nba_game_id], player_id: stat_data[:nba_player_id])

            if new_stat_line
                new_stat_line.update(stat_data)
            else
              StatLine.create(stat_data)
            end
          end
        end
      end

      return "Done"
    end

    def link_builder(game_id)
      game = Game.find_by_nba_id(game_id)
      link = 'http://stats.nba.com/stats/boxscoretraditionalv2?EndPeriod=10&EndRange='
      link += game.quarters == 4 ? '28800' : ((game.quarters.to_i - 4 * 3000) + 28800).to_s
      link += '&GameID='
      link += game_id
      link += '&RangeType=0&Season='
      link += @season
      link += '&SeasonType='
      link += @season_type
      link += '&StartPeriod=1&StartRange=0'

      link
    end

    def grab_specific_stat_line_data(stats)
      stat_line_data = {}
      split_time = stats[8].nil? ? [0,0] : stats[8].split(':')
      adjusted_minutes = split_time[0].to_i + (split_time[1].to_f / 60)

      stat_line_data[:game_id] = stats[0]
      stat_line_data[:team_id] = stats[1]
      stat_line_data[:player_id] = stats[4]
      stat_line_data[:start_position] = stats[6]
      stat_line_data[:minutes] = adjusted_minutes
      stat_line_data[:fgm] = stats[9]
      stat_line_data[:fga] = stats[10]
      stat_line_data[:fg3m] = stats[12]
      stat_line_data[:fg3a] = stats[13]
      stat_line_data[:ftm] = stats[15]
      stat_line_data[:fta] = stats[16]
      stat_line_data[:oreb] = stats[18]
      stat_line_data[:dreb] = stats[19]
      stat_line_data[:ast] = stats[21]
      stat_line_data[:stl] = stats[22]
      stat_line_data[:blk] = stats[23]
      stat_line_data[:to] = stats[24]
      stat_line_data[:pf] = stats[25]
      stat_line_data[:plus_minus] = stats[27]

      stat_line_data
    end
  end
end
