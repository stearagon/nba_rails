module StatCalculators
  class TeamStatsAnalysis
    attr_reader :start_date, :end_date, :league_averages, :game_possessions,
                  :game_points, :team_possessions, :possessions_per_48, :points_per_possession,
                  :team_points_allowed, :points_per_possession_allowed

    def initialize(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date
      @teams = Team.all
      @game_possessions = game_by_game_possessions
      @game_points = game_by_game_points
      @team_points = team_total_points
      @team_points_allowed = team_total_points_allowed
      @team_possessions = team_total_possessions
      @team_minutes = team_total_minutes
      @points_per_possession = team_points_per_possession
      @points_per_possession_allowed = team_points_per_possession_allowed
      @possessions_per_48 = team_possessions_per_48
    end

    def game_stats
      game_stats = {}
      games = Game.includes(:played_stat_lines).where("date BETWEEN ? AND ?", @start_date, @end_date)

      games.each do |game|
        game_stats["#{game.nba_game_id}"] = Hash.new
        game_stats["#{game.nba_game_id}"]["home"] = Hash.new(0)
        game_stats["#{game.nba_game_id}"]["away"] = Hash.new(0)

        game.played_stat_lines.each do |stat_lines|
          game_stats["#{stat_lines.nba_game_id}"]["home"]["fga"] += stat_lines.fga if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fga.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["fgm"] += stat_lines.fgm if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fgm.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["fg3a"] += stat_lines.fg3a if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fg3a.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["fg3m"] += stat_lines.fg3m if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fg3m.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["fta"] += stat_lines.fta if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fta.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["ftm"] += stat_lines.ftm if stat_lines.nba_team_id == game.home_team_id && !stat_lines.ftm.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["oreb"] += stat_lines.oreb if stat_lines.nba_team_id == game.home_team_id && !stat_lines.oreb.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["dreb"] += stat_lines.dreb if stat_lines.nba_team_id == game.home_team_id && !stat_lines.dreb.nil?
          game_stats["#{stat_lines.nba_game_id}"]["home"]["to"] += stat_lines.to if stat_lines.nba_team_id == game.home_team_id && !stat_lines.to.nil?

          game_stats["#{stat_lines.nba_game_id}"]["away"]["fga"] += stat_lines.fga if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fga.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["fgm"] += stat_lines.fgm if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fgm.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["fg3a"] += stat_lines.fg3a if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fg3a.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["fg3m"] += stat_lines.fg3m if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fg3m.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["fta"] += stat_lines.fta if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fta.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["ftm"] += stat_lines.ftm if stat_lines.nba_team_id == game.away_team_id && !stat_lines.ftm.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["oreb"] += stat_lines.oreb if stat_lines.nba_team_id == game.away_team_id && !stat_lines.oreb.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["dreb"] += stat_lines.dreb if stat_lines.nba_team_id == game.away_team_id && !stat_lines.dreb.nil?
          game_stats["#{stat_lines.nba_game_id}"]["away"]["to"] += stat_lines.to if stat_lines.nba_team_id == game.away_team_id && !stat_lines.to.nil?
        end
      end

      game_stats
    end

    def game_by_game_possessions
      game_by_game_possessions = {}

      self.game_stats.each do |k,v|
        game = Game.includes(:home_team, :away_team).find_by(nba_game_id: k)
        game_possessions = possessions_formula(v)
        game_by_game_possessions[k] = { game.home_team[:nba_team_id] => game_possessions[:home],
                                          game.away_team[:nba_team_id] => game_possessions[:away]}
      end

      game_by_game_possessions
    end

    def game_by_game_points
      game_by_game_points = {}

      self.game_stats.each do |k,v|
        game = Game.includes(:home_team, :away_team).find_by(nba_game_id: k)
        game_by_game_points[k] = { game.home_team[:nba_team_id] => points_formula(v["home"]),
                                    game.away_team[:nba_team_id] => points_formula(v["away"])}
      end

      game_by_game_points
    end

    def team_total_possessions
      team_total_possessions = {}

      @teams.each do |team|
        games = team.games.select { |game| game.date >= @start_date && game.date <= @end_date }

        if !games.empty?
          total_possessions = games.map do |game|
            game_possessions[game.nba_game_id].values.inject(:+) / 2.0
          end.inject(:+)

          team_total_possessions[team.nba_team_id] = total_possessions
        end
      end

      team_total_possessions
    end

    def team_total_points
      team_total_points = {}

      @teams.each do |team|
        games = team.games.select { |game| game.date >= @start_date && game.date <= @end_date }

        if !games.empty?
          total_points = games.map do |game|
            game_points[game.nba_game_id][team.nba_team_id]
          end.inject(:+)

          team_total_points[team.nba_team_id] = total_points
        end
      end

      team_total_points
    end

    def team_total_points_allowed
      team_total_points_allowed = {}

      @teams.each do |team|
        games = team.games.select { |game| game.date >= @start_date && game.date <= @end_date }

        if !games.empty?
          total_points_allowed = games.map do |game|
            game_points[game.nba_game_id].values.inject(:+) - game_points[game.nba_game_id][team.nba_team_id]
          end.inject(:+)

          team_total_points_allowed[team.nba_team_id] = total_points_allowed
        end
      end

      team_total_points_allowed
    end

    def team_total_minutes
      team_total_minutes = {}

      @teams.each do |team|
        games = team.games.select { |game| game.date >= @start_date && game.date <= @end_date }

        if !games.empty?
          total_minutes = games.map do |game|
            game.minutes
          end.inject(:+)

          team_total_minutes[team.nba_team_id] = total_minutes
        end
      end

      team_total_minutes
    end

    def team_points_per_possession
      team_points_per_possession = Hash.new(nil)

      @team_points.each do |k,v|
        team_points_per_possession[k] = (v / @team_possessions[k].to_f)
      end

      team_points_per_possession
    end

    def team_points_per_possession_allowed
      team_points_per_possession_allowed = Hash.new(nil)

      @team_points_allowed.each do |k,v|
        team_points_per_possession_allowed[k] = (v / @team_possessions[k].to_f)
      end

      team_points_per_possession_allowed
    end

    def team_possessions_per_48
      team_possessions_per_48 = Hash.new(nil)

      @team_possessions.each do |k,v|
        team_possessions_per_48[k] = (v / @team_minutes[k].to_f) * 48
      end

      team_possessions_per_48
    end

    private

    def possessions_formula(values)
      home_possessions = values["home"]["fga"] +
                            (0.40 * values["home"]["fta"]) -
                            1.07 * (values["home"]["oreb"] / (values["home"]["oreb"] + values["away"]["dreb"]).to_f) *
                            (values["home"]["fga"] - values["home"]["fgm"]) +
                            values["home"]["to"]

      away_possessions = values["away"]["fga"] +
                            (0.40 * values["away"]["fta"]) -
                            1.07 * (values["away"]["oreb"] / (values["away"]["oreb"] + values["home"]["dreb"]).to_f) *
                            (values["away"]["fga"] - values["away"]["fgm"]) +
                            values["away"]["to"]

      game_possessions = { home: home_possessions, away: away_possessions }

      game_possessions
    end

    def points_formula(values)
      points = (values["fgm"] - values["fg3m"]) * 2 +
                  (values["fg3m"]) * 3 +
                  (values["ftm"]) * 1

      points
    end
  end
end
