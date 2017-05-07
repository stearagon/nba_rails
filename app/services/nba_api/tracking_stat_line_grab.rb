module NBAApi
  class TrackingStatLineGrab
    def initialize(date, season, season_type)
      @date = date
      @season = season
      @season_type = season_type
    end

    def get_tracking_stat_lines
      games = Game.where(date: @date)

      if games.present?
        stats_data = []
        games.each do |game|
          if game.completed?
            TrackingStatLine.where(game_id: game.nba_id).delete_all

            p "Starting to get traking stat lines for game##{game.nba_id}"

            begin
              uri = URI(link_builder(game.nba_id))
              user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"

              req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

              res = Net::HTTP.start(uri.hostname, uri.port) {|http|
                  http.request(req)
              }

              tracking_stat_line_json = JSON.parse(res.body)

              tracking_stat_line_json['resultSets'][0]['rowSet'].each do |tracking_stat_line|
                tracking_stat_data = grab_specific_tracking_stat_line_data(tracking_stat_line)
                stats_data << TrackingStatLine.new(tracking_stat_data)

              end

              p "Successfully retrieved Game # #{game.nba_id} tracking stat lines"
            rescue
              p "Failed retrieving Game ##{game.nba_id} tracking stat lines"
            end
          end
        end
        TrackingStatLine.import(stats_data)
      end

      return "Done"
    end

    def link_builder(game_id)
      game = Game.find_by_nba_id(game_id)
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

      tracking_stat_line_data[:game_id] = stats[0]
      tracking_stat_line_data[:team_id] = stats[1]
      tracking_stat_line_data[:player_id] = stats[4]
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
end
