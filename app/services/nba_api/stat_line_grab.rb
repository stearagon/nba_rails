module NBAApi
  class StatLineGrab
    def initialize(date, season, season_type)
      @date = date
      @season = season
      @season_type = season_type
    end

    def get_stat_lines
      start_time = Time.now
      games = Game.where(date: @date)

      if games.present?
        stat_datas = []
        games.each do |game|
          if game.completed?
            StatLine.where(game_id: game.nba_id).delete_all

            p "Starting to get stat lines for game ##{game.nba_id}"

            begin
              uri = URI(link_builder(game.nba_id))
              user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
              p uri

              req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

              res = Net::HTTP.start(uri.hostname, uri.port) {|http|
                  http.request(req)
              }

              stat_line_json = JSON.parse(res.body)
              p stat_line_json
              p stat_line_json['resultSets'][0]['rowSet']

              stat_line_json['resultSets'][0]['rowSet'].each do |stat_line|
                stat_data = grab_specific_stat_line_data(stat_line)
                stat_datas << StatLine.new(stat_data)
              end

              p "Successfully retrieved Game # #{game.nba_id} stat lines"
            rescue
              p "Failed retrieving Game ##{game.nba_id} stat lines"
            end
          end
        end

        StatLine.import(stat_datas)
        end_time = Time.now
        p end_time - start_time
        return "Done"
      end
    end

    def get_quarter_starters(quarter, game)
      add_time = 10
      stat_lines = []
      p link_builder(game.nba_id, { quarter_start: quarter, add_time: add_time  })
      p quarter
      while stat_lines.length < 10
        p link_builder(game.nba_id, { quarter_start: quarter, add_time: add_time  })
        p quarter
        stat_line_json = HTTP.get(link_builder(game.nba_id, { quarter_start: quarter, add_time: add_time  })).parse

        stat_lines = stat_line_json['resultSets'][0]['rowSet']
        add_time += 10
      end

      if stat_lines.length == 10
        grab_quarter_starters(stat_lines, game)
      else
        grab_quarter_starters(stat_lines, game)
        #game.update!(redo_lineups: true)
        #p "starters length not right #{stat_lines.length}"
        #false
      end
    end

    def link_builder(game_id, options={})
      game = Game.find_by_nba_id(game_id)
      end_of_game_range = game.quarters == 4 ? '28800' : ((game.quarters.to_i - 4 * 3000) + 28800).to_s
      start_range = if options[:quarter_start]
        if options[:quarter_start] > 4
          4 * 7200 + 1 + ((options[:quarter_start] - 5) * 3000)
        else
          (options[:quarter_start] - 1) * 7200 + 1
        end
      end
      range_type = options[:quarter_start] ? '2' : '0'
      end_range = if options[:quarter_start]
        if options[:quarter_start] > 4
          4 * 7200 + 1 + ((options[:quarter_start] - 5) * 3000) + options[:add_time]
        else
          (options[:quarter_start] - 1) * 7200 + 1 + options[:add_time]
        end
      end

      link = 'http://stats.nba.com/stats/boxscoretraditionalv2?EndPeriod=10&EndRange='
      link += (end_range || end_of_game_range).to_s
      link += '&GameID='
      link += game_id
      link += '&RangeType='
      link += range_type
      link+= '&Season='
      link += @season
      link += '&SeasonType='
      link += @season_type
      link += '&StartPeriod=1&StartRange='
      link += (start_range || 0).to_s

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

    def grab_quarter_starters(stats, game)
      starters = {
        home: [],
        away: []
      }
      stats.each do |stat_line|
        if stat_line[1].to_s == game.home_team_id
          starters[:home].push(stat_line[4])
        else
          starters[:away].push(stat_line[4])
        end
      end
      starters[:home] = starters[:home].sort { |a,b| b<=>a }
      starters[:away] = starters[:away].sort { |a,b| b<=>a }
      starters
    end
  end
end
