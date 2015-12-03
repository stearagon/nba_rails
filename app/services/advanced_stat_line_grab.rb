class AdvancedStatLineGrab
  def initialize(date, season, season_type)
    @date = date
    @season = season
    @season_type = season_type
  end

  def get_advanced_stat_lines
    games = Game.where(date: @date)

    games.each do |game|
      advanced_stat_line_json = HTTP.get(link_builder(game.nba_game_id)).parse

      advanced_stat_line_json['resultSets'][0]['rowSet'].each do |advanced_stat_line|
        advanced_stat_data = grab_specific_advanced_stat_line_data(advanced_stat_line)
        new_advanced_stat_line = AdvancedStatLine.find_by(nba_game_id: advanced_stat_data[:nba_game_id], nba_player_id: advanced_stat_data[:nba_player_id])

        if new_advanced_stat_line
            new_advanced_stat_line.update(advanced_stat_data)
        else
          AdvancedStatLine.create(advanced_stat_data)
        end
      end
    end

    return "Done"
  end

  def link_builder(game_id)
    game = Game.find_by_nba_game_id(game_id)
    link = 'http://stats.nba.com/stats/boxscoreadvancedv2?EndPeriod=10&EndRange='
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

  def grab_specific_advanced_stat_line_data(stats)
    advanced_stat_line_data = {}
    split_time = stats[8].nil? ? [0,0] : stats[8].split(':')
    adjusted_minutes = split_time[0].to_i + (split_time[1].to_f / 60)

    advanced_stat_line_data[:nba_game_id] = stats[0]
    advanced_stat_line_data[:nba_team_id] = stats[1]
    advanced_stat_line_data[:nba_player_id] = stats[4]
    advanced_stat_line_data[:start_position] = stats[6]
    advanced_stat_line_data[:minutes] = adjusted_minutes
    advanced_stat_line_data[:offensive_rating] = stats[9]
    advanced_stat_line_data[:defensive_rating] = stats[10]
    advanced_stat_line_data[:assist_percentage] = stats[12]
    advanced_stat_line_data[:assist_to_turnover] = stats[13]
    advanced_stat_line_data[:assist_ratio] = stats[14]
    advanced_stat_line_data[:offensive_rebound_percentage] = stats[15]
    advanced_stat_line_data[:defensive_rebound_percentage] = stats[16]
    advanced_stat_line_data[:rebound_percentage] = stats[17]
    advanced_stat_line_data[:team_turnover_percentage] = stats[18]
    advanced_stat_line_data[:effective_field_goal_percentage] = stats[19]
    advanced_stat_line_data[:true_shooting_percentage] = stats[20]
    advanced_stat_line_data[:usage_percentage] = stats[21]
    advanced_stat_line_data[:pace] = stats[22]
    advanced_stat_line_data[:pie] = stats[23]

    advanced_stat_line_data
  end
end
