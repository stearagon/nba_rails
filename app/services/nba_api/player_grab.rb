module NBAApi
  class PlayerGrab
    def initialize(season)
      @season = season
    end

    def get_player_info
        uri = URI(link_builder)
        user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"

        req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
        }

        player_json = JSON.parse(res.body)
        all_player_data = player_json['resultSets'].first['rowSet']

        all_player_data.each do |player|
          player_data = grab_specific_player_data(player)
          player_record = Player.find_by(nba_id: player_data[:nba_id])

          if player_record
            player_record.update_attributes(player_data)
          else
            Player.create(player_data)
          end
        end

      return "Done"
    end

    def link_builder
      link = "http://stats.nba.com/stats/commonallplayers?IsOnlyCurrentSeason=0&LeagueID=00&Season="
      link += @season
      link
    end

    def grab_specific_player_data(player_json)
      player_data = {}

      names = (player_json[1].split(', '))

      if names.size == 1
        last_name, first_name = names[0], names[0]
      else
        last_name, first_name = names[0], names [1]
      end

      player_data[:nba_id] = player_json[0]
      player_data[:first_name] = first_name
      player_data[:last_name] = last_name
      player_data[:rookie_year] = player_json[4]
      player_data[:final_year] = player_json[5]

      player_data
    end
  end
end
