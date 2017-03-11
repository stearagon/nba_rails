class StatsController < ApplicationController
  def index
    if !params[:history_dates].nil?
      @game_start_date = params[:game_dates][:begin_date]
      @game_end_date = params[:game_dates][:end_date]
      @history_start_date = params[:history_dates][:begin_date]
      @history_end_date = params[:history_dates][:end_date]

      @games = Game.includes(:home_team, :away_team).where(:date => @game_start_date..@game_end_date)

      team_stats = StatCalculators::TeamStatsAnalysis.new({
                start_date: @history_start_date,
                end_date: @history_end_date})

      @team_possessions = team_stats.possessions_per_48
      @points_per_possession = team_stats.points_per_possession
      @points_per_possession_allowed = team_stats.points_per_possession_allowed
    end
  end
end
