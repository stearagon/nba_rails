module NBAApi
  class RefereeGrab
    def initialize(date)
      @date = date
    end

    def get_referees
      games = Game.where(date: @date)

      games.each do |game|
        referees_url_get = HTTP.get(link_builder(game.nba_id))
        referees_json = referees_url_get.status != 404 ? referees_url_get.parse['resultSets'][2]['rowSet'] : []

        referees_json.each do |referee|
          referee_data = grab_specific_referee_data(referee)
          referee_record = Referee.find_by(nba_id: referee_data[:nba_id])

          if referee_record.nil?
            Referee.create(referee_data)
          end

          new_game_referee = GameReferee.find_by(game_id: game.nba_id, referee_id: referee_data[:nba_id])
          if new_game_referee.nil?
            GameReferee.create(game_id: game.nba_id, referee_id: referee_data[:nba_id])
          end
        end
      end

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
