class RefereeGrab
  def initialize(date)
    @date = date
  end

  def get_referees
    games = Game.where(date: @date)

    games.each do |game|
      referees_json = HTTP.get(link_builder(game.nba_game_id)).parse['resultSets'][2]['rowSet']

      referees_json.each do |referee|
        referee_data = grab_specific_referee_data(referee)
        referee_record = Referee.find_by_nba_referee_id(referee_data[:nba_referee_id])

        if referee_record.nil?
          Referee.create(referee_data)
        end

        new_game_referee = GameReferee.find_by(game_id: game.nba_game_id, referee_id: referee_data[:nba_referee_id])
        if new_game_referee.nil?
          GameReferee.create(game_id: game.nba_game_id, referee_id: referee_data[:nba_referee_id])
        end
      end
    end

    return "Done"
  end

  def link_builder(game_id)
    link = 'http://stats.nba.com/stats/boxscoresummaryv2?GameID='
    link += game_id

    link
  end

  def grab_specific_referee_data(referee)
    referee_data = {}
    referee_data[:nba_referee_id] = referee[0]
    referee_data[:first_name] = referee[1]
    referee_data[:last_name] = referee[2]
    referee_data[:jersey_number] = referee[3].strip.to_i

    referee_data
  end
end
