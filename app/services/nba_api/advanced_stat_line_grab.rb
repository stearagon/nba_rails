module NBAApi
  class AdvancedStatLineGrab
    def initialize(date, season, season_type)
      @date = date
      @season = season
      @season_type = season_type
    end

    def get_advanced_stat_lines
      games = Game.where(date: @date)

      stats_datas = []
      games.each do |game|
        if game.completed?
          AdvancedStatLine.where(game_id: game.nba_id).delete_all

          p "Starting to get advanced stat lines for game ##{game.nba_id}"

          begin
              uri = URI(link_builder(game.nba_id))
              user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"

              req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

              res = Net::HTTP.start(uri.hostname, uri.port) {|http|
                  http.request(req)
              }

              advanced_stat_line_json = JSON.parse(res.body)

              advanced_stat_line_json['resultSets'][0]['rowSet'].each do |advanced_stat_line|
              advanced_stat_data = grab_specific_advanced_stat_line_data(advanced_stat_line)

              stats_datas << AdvancedStatLine.new(advanced_stat_data)
            end

            p "Successfully retrieved Game # #{game.nba_id} advanced stat lines"
          rescue
            p "Failed retrieving Game ##{game.nba_id} advanced stat lines"
          end
        end
      end

      AdvancedStatLine.import(stats_datas)

      return "Done"
    end

    def link_builder(game_id)
      game = Game.find_by_nba_id(game_id)
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

      advanced_stat_line_data[:game_id] = stats[0]
      advanced_stat_line_data[:team_id] = stats[1]
      advanced_stat_line_data[:player_id] = stats[4]
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
end
