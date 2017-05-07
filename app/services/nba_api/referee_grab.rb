module NBAApi
  class RefereeGrab
    def initialize(date)
      @date = date
    end

    def get_referees
      games = Game.where(date: @date)

      stats_data = []
      games.each do |game|
        if game.completed?
          GameReferee.where(game_id: game.nba_id).delete_all

          p "Starting to get ref data for game ##{game.nba_id}"

          begin
            uri = URI(link_builder(game.nba_id))
            user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"

            req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

            res = Net::HTTP.start(uri.hostname, uri.port) {|http|
                http.request(req)
            }

            referees_json = res.class == Net::HTTPOK ? JSON.parse(res.body)['resultSets'][2]['rowSet'] : []

            referees_json.each do |referee|
              referee_data = grab_specific_referee_data(referee)
              referee_record = Referee.find_by(nba_id: referee_data[:nba_id])

              if referee_record.nil?
                Referee.create(referee_data)
              end

              stats_data << GameReferee.new(game_id: game.nba_id, referee_id: referee_data[:nba_id])
            end
            p "Successfully retrieved Game # #{game.nba_id} ref data"
          rescue
            p "Failes retrieving Game # #{game.nba_id} ref data"
          end
        end
      end
       GameReferee.import(stats_data)

      return "Done"
    end

    def link_builder(game_id)
      link = 'http://stats.nba.com/stats/boxscoresummaryv2?GameID='
      link += game_id.to_s

      link
    end

    def grab_specific_referee_data(referee)
      referee_data = {}
      referee_data[:nba_id] = referee[0]
      referee_data[:first_name] = referee[1]
      referee_data[:last_name] = referee[2]
      referee_data[:jersey_number] = referee[3].strip.to_i

      referee_data
    end
  end
end
