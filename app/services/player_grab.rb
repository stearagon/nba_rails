class PlayerGrab
  def initialize(season)
    @season = season
  end

  def get_player_info
      player_json = HTTP.get(link_builder).parse
      all_player_data = player_json['resultSets'].first['rowSet']

      all_player_data.each do |player|
        player_data = grab_specific_player_data(player)

        player_record = Player.find_by_nba_player_id(player[0])

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

    if names.length == 1
      last_name, first_name = names[0], names[0]
    else
      last_name, first_name = names[0], names [1]
    end

    player_data[:nba_player_id] = player_json[0]
    player_data[:season] = @season
    player_data[:first_name] = first_name
    player_data[:last_name] = last_name
    player_data[:rookie_year] = player_json[3]
    player_data[:final_year] = player_json[4]
    player_data[:nba_team_id] = player_json[6]

    player_data
  end
end
