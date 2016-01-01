class StatsController < ApplicationController
  def index
    if !params[:history_dates].nil?
      @game_start_date = params[:game_dates][:begin_date]
      @game_end_date = params[:game_dates][:end_date]
      @history_start_date = params[:history_dates][:begin_date]
      @history_end_date = params[:history_dates][:end_date]

      @games = Game.includes(:home_team, :away_team).where(:date => @game_start_date..@game_end_date)

      team_stats = TeamStatsAnalysis.new({
                start_date: @history_start_date,
                end_date: @history_end_date})

      @team_possessions = team_stats.team_possessions
      @league_averages = team_stats.league_averages

    end
  end
end
