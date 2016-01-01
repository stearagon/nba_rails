class TeamStatsAnalysis
  attr_reader :start_date, :end_date, :league_averages

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
  end

  def all_possession_stats_fga
    team_stats = {}
    games = Game.includes(:played_stat_lines).where(:date => @start_date..@end_date)
    games.each do |game|
      team_stats["#{game.nba_game_id}"] = Hash.new
      team_stats["#{game.nba_game_id}"]["home"] = Hash.new(0)
      team_stats["#{game.nba_game_id}"]["away"] = Hash.new(0)

      game.played_stat_lines.each do |stat_lines|
        team_stats["#{stat_lines.nba_game_id}"]["home"]["fga"] += stat_lines.fga if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fga.nil?
        team_stats["#{stat_lines.nba_game_id}"]["home"]["fgm"] += stat_lines.fgm if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fgm.nil?
        team_stats["#{stat_lines.nba_game_id}"]["home"]["fta"] += stat_lines.fta if stat_lines.nba_team_id == game.home_team_id && !stat_lines.fta.nil?
        team_stats["#{stat_lines.nba_game_id}"]["home"]["oreb"] += stat_lines.oreb if stat_lines.nba_team_id == game.home_team_id && !stat_lines.oreb.nil?
        team_stats["#{stat_lines.nba_game_id}"]["home"]["dreb"] += stat_lines.dreb if stat_lines.nba_team_id == game.home_team_id && !stat_lines.dreb.nil?
        team_stats["#{stat_lines.nba_game_id}"]["home"]["to"] += stat_lines.to if stat_lines.nba_team_id == game.home_team_id && !stat_lines.to.nil?

        team_stats["#{stat_lines.nba_game_id}"]["away"]["fga"] += stat_lines.fga if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fga.nil?
        team_stats["#{stat_lines.nba_game_id}"]["away"]["fgm"] += stat_lines.fgm if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fgm.nil?
        team_stats["#{stat_lines.nba_game_id}"]["away"]["fta"] += stat_lines.fta if stat_lines.nba_team_id == game.away_team_id && !stat_lines.fta.nil?
        team_stats["#{stat_lines.nba_game_id}"]["away"]["oreb"] += stat_lines.oreb if stat_lines.nba_team_id == game.away_team_id && !stat_lines.oreb.nil?
        team_stats["#{stat_lines.nba_game_id}"]["away"]["dreb"] += stat_lines.dreb if stat_lines.nba_team_id == game.away_team_id && !stat_lines.dreb.nil?
        team_stats["#{stat_lines.nba_game_id}"]["away"]["to"] += stat_lines.to if stat_lines.nba_team_id == game.away_team_id && !stat_lines.to.nil?
      end
    end

    team_possessions = {}

    team_stats.each do |k,v|
      team_possessions[k] = possession_formula(v) / Game.find_by(nba_game_id: k).minutes * 48
    end

    @league_averages = team_possessions.values.inject(:+) / team_stats.length

    team_possessions
  end

  def team_possessions
    game_possessions = all_possession_stats_fga
    teams = Team.all
    team_possessions = {}

    teams.each do |team|
      games = team.games.select { |game| game.date >= @start_date && game.date <= @end_date }

      if !games.empty?
        average_possessions = games.map do |game|
          game_possessions[game.nba_game_id]
        end.inject(:+) / games.length

        team_possessions[team.nba_team_id] = average_possessions
      end
    end

    team_possessions
  end

  def possession_formula(values)
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

    game_possessions = (home_possessions + away_possessions) / 2.0
    game_possessions
  end
end
