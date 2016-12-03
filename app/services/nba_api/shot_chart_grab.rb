module NBAApi
  class ShotChartGrab
    def initialize(date, season, season_type)
      @date = date
      @season = season
      @season_type = season_type
    end

    def get_shot_charts
      games = Game.where(date: @date)

      games.each do |game|
        game.stat_lines.each do |stat_line|
          player = stat_line.player
          team = stat_line.team

          shot_chart_json = HTTP.get(link_builder(player, game, stat_line)).parse

          shot_chart_json['resultSets'][0]['rowSet'].each do |shot_chart|
            shot_chart_data = grab_specific_shot_chart_data(shot_chart)
            new_shot_chart = ShotChart.find_by(game_id: shot_chart_data[:nba_game_id],
              player_id: player.nba_id, period: shot_chart_data[:period],
              minutes_left: shot_chart_data[:minutes_left], seconds_left: shot_chart_data[:seconds_left])

            if new_shot_chart
              new_shot_chart.update(shot_chart_data)
            else
              ShotChart.create(shot_chart_data)
            end
          end
        end
      end

      return "Done"
    end

    def link_builder(player, game, stat_line)
      link = 'http://stats.nba.com/stats/shotchartdetail?CFID=&CFPARAMS=&ContextFilter=&ContextMeasure=FGA&DateFrom=&DateTo=&EndPeriod=10&EndRange='
      link += game.quarters == 4 ? '28800' : ((game.quarters.to_i - 4 * 3000) + 28800).to_s
      link += '&GameID='
      link += game.nba_id
      link += '&GameSegment=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&Period=0&PlayerID='
      link += player.nba_id.to_s
      link += '&Position=&RangeType=0&RookieYear=&Season='
      link += @season
      link += '&SeasonSegment=&SeasonType='
      link += @season_type
      link += '&StartPeriod=1&StartRange=0&TeamID='
      link += stat_line.team.nba_id.to_s
      link += '&VsConference=&VsDivision=&mtitle=&mtype=&PlayerPosition=';

      link
    end

    def grab_specific_shot_chart_data(stats)
      shot_chart_data = {}

      shot_chart_data[:game_id] = stats[1]
      shot_chart_data[:grid_type] = stats[0]
      shot_chart_data[:player_id] = stats[3]
      shot_chart_data[:team_id] = stats[5]
      shot_chart_data[:period] = stats[7]
      shot_chart_data[:minutes_left] = stats[8]
      shot_chart_data[:seconds_left] = stats[9]
      shot_chart_data[:event_type] = stats[10]
      shot_chart_data[:action_type] = stats[11]
      shot_chart_data[:shot_type] = stats[12]
      shot_chart_data[:zone_basic] = stats[13]
      shot_chart_data[:zone_area] = stats[14]
      shot_chart_data[:zone_range] = stats[15]
      shot_chart_data[:distance] = stats[16]
      shot_chart_data[:location_x] = stats[17]
      shot_chart_data[:location_y] = stats[18]
      shot_chart_data[:made_shot?] = stats[20]

      shot_chart_data
    end
  end
end
