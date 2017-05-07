module NBAApi
  class GameGrab
    def initialize(date, season_start_year)
      @date = date
      @season_start_year = season_start_year
    end

    def get_games
      p link_builder
      uri = URI(link_builder)
      user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"

      req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
          http.request(req)
      }

      games_json = res.class == Net::HTTPOK ? JSON.parse(res.body)['games'] : []

      games_json.each do |game|
        game_data = grab_specific_game_data(game)
        game_record = ::Game.find_by(nba_id: game['gid'])

        if game_record
          game_record.update_attributes(game_data)
        else
          ::Game.create(game_data)
        end
      end

      return "Done"
    end

    def link_builder
      link = "http://data.nba.com/data/1m/json/nbacom/"
      link += @season_start_year
      link += "/gameline/"
      link += @date
      link += "/games.json"

      link
    end

    def grab_specific_game_data(game)
      game_data = {}
      game_data[:nba_id] = game['gid'].to_s
      game_data[:date] = date_time_format(@date)
      game_data[:completed?] = game['recap'] != ''
      game_data[:overtime?] = game['ot'] > 0
      game_data[:quarters] = game['qts'].length
      game_data[:national_game?] = game['broadcaster']['is_national']
      game_data[:TNT?] = game['broadcaster']['name'] == 'TNT'
      game_data[:away_team_id] = game['teams'].first['id']
      game_data[:home_team_id] = game['teams'].last['id']
      game_data
    end

    def date_time_format(date)
      "#{date[0..3]}-#{date[4..5]}-#{date[-2..-1]}"
    end
  end
end
