module ModelFinder
  class StatLine
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def find
      scope = ::StatLine.distinct
      params.keys.reduce(scope) do |scope, param|
        if searchable_params.include?(param)
          self.send(param, scope, params)
        else
          scope
        end
      end
    end

    def find_team_stats
      scope = ::StatLine
      new_params = {}
      new_params[:team_ids] = [@params[:home_team_id].to_i, @params[:away_team_id].to_i]
      new_params[:date] = @params[:date]
      new_params[:period] = @params[:data_inputs]['date-period']
      new_params[:data_name] = @params[:data_inputs][:data1]

      new_params.keys.reduce(scope) do |scope, param|
        if searchable_params.include?(param)
          if param == :period
            self.send(param, scope, new_params)
          else
            self.send(param, scope, new_params)
          end
        else
          scope
        end
      end
    end

    def team_ids(scope, params)
      scope
        .joins('LEFT JOIN teams ON stat_lines.team_id = teams.nba_id')
        .where("teams.id = ANY(array[?])",
          params[:team_ids])
    end

    def period(scope, params)
      date_before_game = Date.parse(params[:date]) - 1.days
      period_start_date =
        date_before_game -  params[:period].to_f.days
      scope
        .joins('LEFT JOIN games ON stat_lines.game_id = games.nba_id')
        .select("games.date, teams.id AS reg_team_id, games.id AS reg_game_id, teams.nba_id, games.nba_id")
        .group("date, reg_team_id, reg_game_id, games.nba_id, teams.nba_id")
        .where("games.date BETWEEN ? AND ?",
          "#{period_start_date.beginning_of_day}",
          "#{date_before_game.end_of_day}")
    end

    def data_name(scope, params)
      if params[:data_name]
        send(params[:data_name], scope)
      else
        scope
      end
    end

    def name(scope, params)
      scope
        .joins(:player)
        .where("LOWER(players.first_name) LIKE LOWER(?)
          OR LOWER(players.last_name) LIKE LOWER(?)
          OR LOWER((players.first_name || ' ' || players.last_name)) LIKE LOWER(?)",
          "%#{params[:name]}%",
          "%#{params[:name]}%",
          "%#{params[:name]}%")
    end

    def team(scope, params)
      scope
      .joins(:team)
        .where("LOWER(teams.city) LIKE LOWER(?)
          OR LOWER(teams.mascot) LIKE LOWER(?)
          OR LOWER((teams.city || ' ' || teams.mascot)) LIKE LOWER(?)",
          "%#{params[team]}%",
          "%#{params[team]}%",
          "%#{params[team]}%")
    end

    private

    def searchable_params
      %i(name team team_ids data_name period)
    end

    def points_per_game(scope)
        scope
          .select("(((SUM(stat_lines.fgm) - SUM(stat_lines.fg3m)) * 2)
            + (SUM(stat_lines.fg3m) * 3)
            + (SUM(stat_lines.ftm) * 1)) as value")
    end

    def allowed_total_points(scope)
        scope
          .joins("LEFT JOIN (
              SELECT ((SUM(inner_sl.fgm) - SUM(inner_sl.fg3m)) * 2
              + (SUM(inner_sl.fg3m) * 3)
              + (SUM(inner_sl.ftm) * 1)) as points,
                inner_sl.game_id,
                inner_sl.team_id
              FROM stat_lines AS inner_sl
              GROUP BY inner_sl.game_id,
                inner_sl.team_id) AS opp
              ON opp.game_id = games.nba_id
                AND opp.team_id != teams.nba_id")
          .group("opp.points")
          .select("opp.points AS value")
    end

    def possessions_per_game(scope)
        scope
          .joins("LEFT JOIN (
              SELECT SUM(inner_sl.dreb) AS dreb,
                inner_sl.game_id,
                inner_sl.team_id
              FROM stat_lines AS inner_sl
              GROUP BY inner_sl.game_id,
                inner_sl.team_id) AS opp
              ON opp.game_id = games.nba_id
                AND opp.team_id != teams.nba_id")
          .group("opp.dreb")
          .select("SUM(stat_lines.fga)
            + (0.4 * SUM(stat_lines.fta))
            - 1.07 * (SUM(stat_lines.oreb) / round((SUM(stat_lines.oreb) + opp.dreb), 2))
            * (SUM(stat_lines.fga) - SUM(stat_lines.fgm))
            + SUM(stat_lines.to) as value")
    end

    def points_per_possession(scope)
        scope
          .joins("LEFT JOIN (
              SELECT SUM(inner_sl.dreb) AS dreb,
                inner_sl.game_id,
                inner_sl.team_id
              FROM stat_lines AS inner_sl
              GROUP BY inner_sl.game_id,
                inner_sl.team_id) AS opp
              ON opp.game_id = games.nba_id
                AND opp.team_id != teams.nba_id")
          .group("opp.dreb")
          .select("((((SUM(stat_lines.fgm) - SUM(stat_lines.fg3m)) * 2)
            + (SUM(stat_lines.fg3m) * 3)
            + (SUM(stat_lines.ftm) * 1)) /  (SUM(stat_lines.fga)
            + (0.4 * SUM(stat_lines.fta))
            - 1.07 * (SUM(stat_lines.oreb) / round((SUM(stat_lines.oreb) + opp.dreb), 2))
            * (SUM(stat_lines.fga) - SUM(stat_lines.fgm))
            + SUM(stat_lines.to))) AS value")
    end

    def allowed_points_per_possession(scope)
        scope
          .joins("LEFT JOIN (
              SELECT SUM(inner_sl.dreb) AS dreb,
                SUM(inner_sl.fgm) AS fgm,
                SUM(inner_sl.fg3m) AS fg3m,
                SUM(inner_sl.ftm) AS ftm,
                inner_sl.game_id,
                inner_sl.team_id
              FROM stat_lines AS inner_sl
              GROUP BY inner_sl.game_id,
                inner_sl.team_id) AS opp
              ON opp.game_id = games.nba_id
                AND opp.team_id != teams.nba_id")
          .group("opp.dreb, opp.fgm, opp.ftm, opp.fg3m")
          .select("((((opp.fgm - opp.fg3m) * 2)
            + (opp.fg3m * 3)
            + (opp.ftm * 1)) /  (SUM(stat_lines.fga)
            + (0.4 * SUM(stat_lines.fta))
            - 1.07 * (SUM(stat_lines.oreb) / round((SUM(stat_lines.oreb) + opp.dreb), 2))
            * (SUM(stat_lines.fga) - SUM(stat_lines.fgm))
            + SUM(stat_lines.to))) AS value")
    end
  end
end
