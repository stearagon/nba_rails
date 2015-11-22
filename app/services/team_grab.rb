class TeamGrab
  TEAM_CODES = {"Atlanta Hawks"=>1610612737,
   "Boston Celtics"=>1610612738,
   "Brooklyn Nets"=>1610612751,
   "Charlotte Hornets"=>1610612766,
   "Chicago Bulls"=>1610612741,
   "Cleveland Cavaliers"=>1610612739,
   "Dallas Mavericks"=>1610612742,
   "Denver Nuggets"=>1610612743,
   "Detroit Pistons"=>1610612765,
   "Golden State Warriors"=>1610612744,
   "Houston Rockets"=>1610612745,
   "Indiana Pacers"=>1610612754,
   "Los Angeles Clippers"=>1610612746,
   "Los Angeles Lakers"=>1610612747,
   "Memphis Grizzlies"=>1610612763,
   "Miami Heat"=>1610612748,
   "Milwaukee Bucks"=>1610612749,
   "Minnesota Timberwolves"=>1610612750,
   "New Orleans Pelicans"=>1610612740,
   "New York Knicks"=>1610612752,
   "Oklahoma City Thunder"=>1610612760,
   "Orlando Magic"=>1610612753,
   "Philadelphia 76ers"=>1610612755,
   "Phoenix Suns"=>1610612756,
   "Portland Trail Blazers"=>1610612757,
   "Sacramento Kings"=>1610612758,
   "San Antonio Spurs"=>1610612759,
   "Toronto Raptors"=>1610612761,
   "Utah Jazz"=>1610612762,
   "Washington Wizards"=>1610612764}

  def initialize(season)
    @season = season
  end

  def get_team_info
    TEAM_CODES.each do |name, id|
      team_json = HTTP.get(link_builder(id)).parse
      team_data = grab_specific_team_data(team_json['resultSets'].first['rowSet'][0])
      team_record = Team.find_by_nba_team_id(team_data[:nba_team_id])

      if team_record
        team_record.update_attributes(team_data)
      else
        Team.create(team_data)
      end
    end

    return "Done"
  end

  def link_builder(team_id)
    link = "http://stats.nba.com/stats/teaminfocommon?LeagueID=00&SeasonType=Regular+Season&TeamID="
    link += team_id.to_s
    link += "&season="
    link += @season
    link
  end

  def grab_specific_team_data(team_json)
    team_data = {}

    team_data[:nba_team_id] = team_json[0]
    team_data[:season] = @season
    team_data[:city] = team_json[2]
    team_data[:mascot] = team_json[3]
    team_data[:abbreviation] = team_json[4]
    team_data[:conference] = team_json[5]
    team_data[:division] = team_json[6]

    team_data
  end
end
