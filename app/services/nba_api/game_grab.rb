module NBAApi
  class GameGrab
    def initialize(date, season_start_year)
      @date = date
      @season_start_year = season_start_year
    end

    def get_games
      games_url_get = HTTP.get(link_builder)
      games_json = games_url_get.status != 404 ? games_url_get.parse['games'] : []

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