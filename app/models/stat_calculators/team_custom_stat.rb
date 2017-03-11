module StatCalculators
    class TeamCustomStat
        attr_reader :start_date, :end_date, :team_id
        attr_accessor :games_filtered, :game_stats, :games_filtered, :games

        def initialize(params)
            @start_date = params[:start_date]
            @end_date = params[:end_date]
            @team_id = params[:team_id]
            # @number_of_games = params[:number_of_games]
            self.games_by_dates
            self.game_stats
        end

        def get_possessions_by_games
            games = games_by_number
        end

        def games_by_number
            Game.includes(:stat_lines)
                .where(completed?: true)
                .where(
                    "(home_team_id = ? OR away_team_id = ?)",
                    @team_id,
                    @team_id,
                )
                .order(:date)
                .limit(@number_of_games)
        end

        def get_possessions_by_dates
        end

        def games_by_dates
            @games = Game
                .includes(:stat_lines)
                .where(completed?: true)
                .where(
                    "(home_team_id = ? OR away_team_id = ?) AND (date BETWEEN ? AND ?)",
                    @team_id,
                    @team_id,
                    @start_date,
                    @end_date
                )

            @games_filtered = @games
        end

        def home_or_away_games(location)
            location_text = location == "home" ? "home_team_id" : "away_team_id"

            @games_filtered = @games.select { |game| game.send(location_text) == @team_id}
        end

        def days_rest_games(rest)
            home_games = home_or_away_games("home").select { |game| game.rests[:home_team] == rest }
            away_games = home_or_away_games("away").select { |game| game.rests[:away_team] == rest }

            @games_filtered = home_games + away_games
        end

        def games_played_in_5(days)
            home_games = home_or_away_games("home").select { |game| game.games_in_5_days[:home_team] == days }
            away_games = home_or_away_games("away").select { |game| game.games_in_5_days[:away_team] == days }

            @games_filtered = home_games + away_games
        end

        def games_played_in_10(days)
            home_games = home_or_away_games("home").select { |game| game.games_in_10_days[:home_team] == days }
            away_games = home_or_away_games("away").select { |game| game.games_in_10_days[:away_team] == days }

            @games_filtered = home_games + away_games
        end

        def game_stats
            game_stats = {}

            @games_filtered.each do |game|
            game_stats["#{game.nba_id}"] = Hash.new
            game_stats["#{game.nba_id}"]["home"] = Hash.new(0)
            game_stats["#{game.nba_id}"]["away"] = Hash.new(0)

            game.played_stat_lines.each do |stat_lines|
                game_stats["#{stat_lines.game_id}"]["home"]["fga"] += stat_lines.fga if stat_lines.team_id == game.home_team_id && !stat_lines.fga.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["fgm"] += stat_lines.fgm if stat_lines.team_id == game.home_team_id && !stat_lines.fgm.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["fg3a"] += stat_lines.fg3a if stat_lines.team_id == game.home_team_id && !stat_lines.fg3a.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["fg3m"] += stat_lines.fg3m if stat_lines.team_id == game.home_team_id && !stat_lines.fg3m.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["fta"] += stat_lines.fta if stat_lines.team_id == game.home_team_id && !stat_lines.fta.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["ftm"] += stat_lines.ftm if stat_lines.team_id == game.home_team_id && !stat_lines.ftm.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["oreb"] += stat_lines.oreb if stat_lines.team_id == game.home_team_id && !stat_lines.oreb.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["dreb"] += stat_lines.dreb if stat_lines.team_id == game.home_team_id && !stat_lines.dreb.nil?
                game_stats["#{stat_lines.game_id}"]["home"]["to"] += stat_lines.to if stat_lines.team_id == game.home_team_id && !stat_lines.to.nil?
                game_stats["#{stat_lines.game_id}"][:home_team_id] = game.home_team_id

                game_stats["#{stat_lines.game_id}"]["away"]["fga"] += stat_lines.fga if stat_lines.team_id == game.away_team_id && !stat_lines.fga.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["fgm"] += stat_lines.fgm if stat_lines.team_id == game.away_team_id && !stat_lines.fgm.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["fg3a"] += stat_lines.fg3a if stat_lines.team_id == game.away_team_id && !stat_lines.fg3a.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["fg3m"] += stat_lines.fg3m if stat_lines.team_id == game.away_team_id && !stat_lines.fg3m.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["fta"] += stat_lines.fta if stat_lines.team_id == game.away_team_id && !stat_lines.fta.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["ftm"] += stat_lines.ftm if stat_lines.team_id == game.away_team_id && !stat_lines.ftm.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["oreb"] += stat_lines.oreb if stat_lines.team_id == game.away_team_id && !stat_lines.oreb.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["dreb"] += stat_lines.dreb if stat_lines.team_id == game.away_team_id && !stat_lines.dreb.nil?
                game_stats["#{stat_lines.game_id}"]["away"]["to"] += stat_lines.to if stat_lines.team_id == game.away_team_id && !stat_lines.to.nil?
                game_stats["#{stat_lines.game_id}"][:away_team_id] = game.away_team_id
            end
            end

            @game_stats = game_stats
        end

        def game_by_game_possessions
            game_by_game_possessions = {}

            @game_stats.each do |k,v|
            game_possessions = possessions_formula(v)
            game_by_game_possessions[k] = { v[:home_team_id] => game_possessions[:home],
                                                v[:away_team_id] => game_possessions[:away]}
            end

            game_by_game_possessions
        end

        def game_by_game_points
            game_by_game_points = {}

            @game_stats.each do |k,v|
            game_by_game_points[k] = { v[:home_team_id] => points_formula(v["home"]),
                                        v[:away_team_id] => points_formula(v["away"])}
            end

            game_by_game_points
        end

        def team_total_possessions
            if !@games_filtered.empty?
            total_possessions = @games_filtered.map do |game|
                game_by_game_possessions[game.nba_id].values.inject(:+) / 2.0
            end.inject(:+)
            end

            total_possessions
        end

        def team_total_points
            if !@games_filtered.empty?
              total_points = @games_filtered.map do |game|
                  game_by_game_points[game.nba_id][@team_id]
              end.inject(:+)
            end

            total_points
        end

        def team_total_points_allowed
            if !@games_filtered.empty?
              total_points_allowed = @games_filtered.map do |game|
                  game_by_game_points[game.nba_id].values.inject(:+) - game_by_game_points[game.nba_id][@team_id]
              end.inject(:+)
            end

            total_points_allowed
        end

        def team_total_minutes
            if !@games_filtered.empty?
            total_minutes = @games_filtered.map do |game|
                game.minutes
            end.inject(:+)
            end

            total_minutes
        end

        def team_points_per_possession
            (team_total_points / team_total_possessions.to_f) if !team_total_points.nil? && !team_total_possessions.nil?
        end

        def team_points_per_possession_allowed
            (team_total_points_allowed / team_total_possessions.to_f) - opponents_average if !team_total_points_allowed.nil? && !team_total_possessions.nil?
        end

        def team_possessions_per_minute
            (team_total_possessions / team_total_minutes.to_f) if !team_total_possessions.nil? && !team_total_minutes.nil?
        end

        def opponents_average
            if !@games_filtered.empty?
            opponents = []

            @games_filtered.each do |game|
                opponents.push(game.home_team_id)
                opponents.push(game.away_team_id)
            end

            opponents = opponents.select { |opp_id| @team_id != opp_id }
            opponents_numbers = {}
            opponents.each do |opponent|
                opponents_numbers[opponent] = TeamCustomStat.new(start_date: @start_date, end_date: @end_date, team_id: opponent).team_points_per_possession
            end

            return (opponents_numbers.values.inject(:+) / opponents_numbers.length)
            end
        end

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
