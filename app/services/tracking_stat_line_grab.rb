class TrackingStatLineGrab
  def initialize(date, season, season_type)
    @date = date
    @season = season
    @season_type = season_type
  end

  def get_tracking_stat_lines
    games = Game.where(date: @date)

    games.each do |game|
      tracking_stat_line_json = HTTP.get(link_builder(game.nba_game_id)).parse

      tracking_stat_line_json['resultSets'][0]['rowSet'].each do |tracking_stat_line|
        tracking_stat_data = grab_specific_tracking_stat_line_data(tracking_stat_line)
        new_tracking_stat_line = TrackingStatLine.find_by(nba_game_id: tracking_stat_data[:nba_game_id], nba_player_id: tracking_stat_data[:nba_player_id])
        if new_tracking_stat_line
            new_tracking_stat_line.update(tracking_stat_data)
        else
          TrackingStatLine.create(tracking_stat_data)
        end
      end
    end

    return "Done"
  end

  def link_builder(game_id)
    game = Game.find_by_nba_game_id(game_id)
    link = 'http://stats.nba.com/stats/boxscoreplayertrackv2?EndPeriod=10&EndRange='
    link += game.quarters == 4 ? '28800' : ((game.quarters.to_i - 4 * 3000) + 28800).to_s
    link += '&GameID='
    link += game_id
    link += '&RangeType=2&Season='
    link += @season
    link += '&SeasonType='
    link += @season_type
    link += '&StartPeriod=1&StartRange=0'

    link
  end

  def grab_specific_tracking_stat_line_data(stats)
    tracking_stat_line_data = {}
    split_time = stats[8].nil? ? [0,0] : stats[8].split(':')
    adjusted_minutes = split_time[0].to_i + (split_time[1].to_f / 60)

    tracking_stat_line_data[:nba_game_id] = stats[0]
    tracking_stat_line_data[:nba_team_id] = stats[1]
    tracking_stat_line_data[:nba_player_id] = stats[4]
    tracking_stat_line_data[:start_position] = stats[6]
    tracking_stat_line_data[:minutes] = adjusted_minutes
    tracking_stat_line_data[:speed] = stats[9]
    tracking_stat_line_data[:distance] = stats[10]
    tracking_stat_line_data[:offensive_rebound_chance] = stats[11]
    tracking_stat_line_data[:defensive_rebound_chance] = stats[12]
    tracking_stat_line_data[:rebound_chance] = stats[13]
    tracking_stat_line_data[:touches] = stats[14]
    tracking_stat_line_data[:secondary_assists] = stats[15]
    tracking_stat_line_data[:free_throw_assists] = stats[16]
    tracking_stat_line_data[:passes] = stats[17]
    tracking_stat_line_data[:contested_field_goals_made] = stats[19]
    tracking_stat_line_data[:contested_field_goals_attemtped] = stats[20]
    tracking_stat_line_data[:uncontested_field_goals_made] = stats[22]
    tracking_stat_line_data[:uncontested_field_goals_attemtped] = stats[23]
    tracking_stat_line_data[:defending_field_goals_made] = stats[26]
    tracking_stat_line_data[:defending_field_goals_attemtped] = stats[27]

    tracking_stat_line_data
  end
end
