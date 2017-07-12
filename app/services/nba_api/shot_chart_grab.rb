module NBAApi
  class ShotChartGrab
    def initialize(date, season, season_type)
      @date = date
      @season = season
      @season_type = season_type
    end

    def get_shot_charts
      games = Game.where(date: @date)
      stats_data = []

      games.each do |game|
        if game.completed?
          ShotChart.where(game_id: game.nba_id).delete_all

          p "Starting to get shot charts for game ##{game.nba_id}"

          game.stat_lines.each do |stat_line|
            player = stat_line.player
            team = stat_line.team

            begin
              uri = URI(link_builder(player, game, stat_line))
              user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
              p uri

              req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

              res = Net::HTTP.start(uri.hostname, uri.port) {|http|
                  http.request(req)
              }

              shot_chart_json = JSON.parse(res.body)

              shot_chart_json['resultSets'][0]['rowSet'].each do |shot_chart|
                shot_chart_data = grab_specific_shot_chart_data(shot_chart)

                stats_data << ShotChart.new(shot_chart_data)
              end

              p "Successfully retrieved Game # #{game.nba_id} shot charts"
            rescue
              p "Failed retrieving Game ##{game.nba_id} shot charts"
            end
          end
        end
      end

      ShotChart.import(stats_data)

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
