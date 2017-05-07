module NBAApi
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
        uri = URI(link_builder(id))
        user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"

        req = Net::HTTP::Get.new(uri, { 'User-Agent' => user_agent })

        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
            http.request(req)
        }

        team_json = JSON.parse(res.body)
        team_data = grab_specific_team_data(team_json['resultSets'].first['rowSet'][0])
        team_record = Team.where(nba_id: team_data[:nba_id]).first
        city_record = City.where(name: team_data[:city], season: @season, team_id: team_data[:nba_id]).first

        if team_record
          team_record.update_attributes(team_data)
        else
          Team.create(
            nba_id: team_data[:nba_id],
            mascot: team_data[:mascot],
            abbreviation: team_data[:abbreviation],
            conference: team_data[:conference],
            division: team_data[:division]
          )
        end

        if city_record.nil?
          City.create(name: team_data[:city], season: @season, team_id: team_data[:nba_id])
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
      p team_json

      team_data[:nba_id] = team_json[0]
      team_data[:city] = team_json[2]
      team_data[:mascot] = team_json[3]
      team_data[:abbreviation] = team_json[4]
      team_data[:conference] = team_json[5]
      team_data[:division] = team_json[6]

      team_data
    end
  end
end
