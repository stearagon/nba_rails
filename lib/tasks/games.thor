require 'thor/rails'
require 'active_record'
require 'http'
require_relative "../../lib/helpers/season_helper.rb"
require_relative "../../app/services/nba_api/game_grab.rb"
require_relative "../../app/models/game.rb"

class Games < Thor
  include Thor::Rails

  desc "grab_games", "grab games for specific range of dates"
  def grab_games(start_date, end_date=nil)
    start, endd, season = parsed_dates(start_date, end_date)

    games = []

    (start..endd).each do |date|
      formatted_date = date.strftime("%Y%m%d")
      game_grab = ::NBAApi::GameGrab.new(formatted_date, season)
      game_grab.get_games

      p "Done with #{date}"
    end
  end

  desc "grab_stats", "grab stats for specific range of games"
  def grab_stats(start_date, end_date=nil)
    start, endd, season = parsed_dates(start_date, end_date)

    (start..endd).each do |date|
      ::NBAApi::StatLineGrab.new(date, season, 'Regular+Season').get_stat_lines
      p "updated stat lines for #{date}"

      ::NBAApi::TrackingStatLineGrab.new(date, season, 'Regular+Season').get_tracking_stat_lines
      p "updated tracking stat lines for #{date}"

      ::NBAApi::AdvancedStatLineGrab.new(date, season, 'Regular+Season').get_advanced_stat_lines
      p "updated advanced stat lines for #{date}"

      ::NBAApi::RefereeGrab.new(date).get_referees
      p "updated refs for #{date}"

      shot_chart_season = ::Helpers::SeasonHelper.season_finder(date)
      ::NBAApi::ShotChartGrab.new(date, shot_chart_season, 'Regular+Season').get_shot_charts
      p "updated shot charts for #{date}"
    end
  end

  desc "grab_plays", "grab plays for specific range of games"
  def grab_plays(start_date, end_date=nil)
    start, endd, season = parsed_dates(start_date, end_date)
    games = ::Game.where("date BETWEEN '#{start_date}' AND '#{end_date}'")

    games.each do |game|
      ::NBAApi::PlayByPlayGrab.new(game.nba_id, 'Regular+Season').get_plays
      p "updated plays for game id: #{game.nba_id}"
    end
  end

  desc "grab_game_and_stats", "grab games and stats for specific range of games"
  def grab_game_and_stats(start_date, end_date=nil)
    grab_games(start_date, end_date)
    grab_stats(start_date, end_date)
  end

  private

  def parsed_dates(start_date, end_date)
    start = Date.parse(start_date)
    endd = end_date ? Date.parse(end_date) : start
    season = ::Helpers::SeasonHelper.start_year(start)

    [start, endd, season]
  end
end
