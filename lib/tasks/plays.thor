require 'thor/rails'
require 'active_record'
require 'http'
require_relative "../../lib/helpers/season_helper.rb"
require_relative "../../app/models/game.rb"
require_relative "../../app/models/lineup.rb"
require_relative "../../app/services/nba_api/stat_line_grab.rb"

class Plays < Thor
  include Thor::Rails

  desc "get_play_lineups_for_range", "determine lineup for a range of game's plays"
  def get_play_lineups_for_range(start_date, end_date=nil)
    start, endd = parsed_dates(start_date, end_date)
    games = Game.where('date BETWEEN ? AND ?', start, endd)

    games.each do |game|
      p game.nba_id
      self.get_play_lineups(game.nba_id)
    end
  end

  desc "get_play_lineups", "determine lineup for a game's plays"
  def get_play_lineups(game_id)
    game = Game.find_by(nba_id: game_id)
    home_players = game.home_starters.map { |p| p.nba_id.to_s }
    away_players = game.away_starters.map { |p| p.nba_id.to_s }

    home_lineup = Lineup.create_lineup(home_players)
    away_lineup = Lineup.create_lineup(away_players)
    plays = game.sorted_plays

    plays.each_with_index do |play, idx|
      if play.event_msg_type == 8
        p home_lineup.players_array.index(play.player_1_id.to_s)
        p away_lineup.players_array.index(play.player_1_id.to_s)
        p play.home_description
        p play.neutral_description
        p play.visitor_description
        p play.id
        p play.player_1_id.to_s
        p play.player_2_id.to_s
        if home_lineup.players_array.index(play.player_1_id.to_s)
          home_lineup_result = handle_substitution(home_lineup, play.player_1_id.to_s, play.player_2_id.to_s)

          if home_lineup_result == nil
            game.update(redo_lineups: true)
            p 'Not a lineup of 5 or duplicate player'
            break
          end

          home_lineup = home_lineup_result
        elsif away_lineup.players_array.index(play.player_1_id.to_s)
          away_lineup_result = handle_substitution(away_lineup, play.player_1_id.to_s, play.player_2_id.to_s)

          if away_lineup_result == nil
            game.update(redo_lineups: true)
            p 'Not a lineup of 5 or duplicate player'
            break
          end

          away_lineup = away_lineup_result
        else
          game.update!(redo_lineups: true)
          p 'not in lineups'
          break
        end
      elsif play.event_msg_type == 12 && play.period != 1
        season = ::Helpers::SeasonHelper.season_finder(game.date)
        starters = ::NBAApi::StatLineGrab.new(game.date, season, 'Regular%20Season').get_quarter_starters(play.period, game)
        if starters == false || starters[:home].length != 5 || starters[:home].uniq.count < 5 || starters[:away].length != 5 || starters[:away].uniq.count < 5
          game.update!(redo_lineups: true)
          p 'catch all error'
          break
        end

        home_lineup = Lineup.create_lineup(starters[:home])
        away_lineup = Lineup.create_lineup(starters[:away])
      end

      play.update_attributes(home_lineup_id: home_lineup.id, away_lineup_id: away_lineup.id)
    end

    p "done with game #{game.nba_id}"
  end

  desc "get_play_lineups_from_play", "determine lineup for a game's plays"
  def get_play_lineups_from_play(game_id, play_id)
    game = Game.find_by(nba_id: game_id)
    play = Play.find(play_id)

    home_lineup = Lineup.find(play.home_lineup_id)
    away_lineup = Lineup.find(play.away_lineup_id)

    plays = game.sorted_plays
    not_yet = true

    plays.each_with_index do |play, idx|
      not_yet = false if play.id.to_s == play_id
      next if not_yet == true || (not_yet == false && play.id.to_s == play_id)
      if play.event_msg_type == 8
        p home_lineup.players_array.index(play.player_1_id.to_s)
        p away_lineup.players_array.index(play.player_1_id.to_s)
        p play.home_description
        p play.neutral_description
        p play.visitor_description
        p play.id
        p play.player_1_id.to_s
        p play.player_2_id.to_s
        if home_lineup.players_array.index(play.player_1_id.to_s)
          home_lineup_result = handle_substitution(home_lineup, play.player_1_id.to_s, play.player_2_id.to_s)

          if home_lineup_result == nil
            game.update(redo_lineups: true)
            p 'Not a lineup of 5 or duplicate player'
            break
          end

          home_lineup = home_lineup_result
        elsif away_lineup.players_array.index(play.player_1_id.to_s)
          away_lineup_result = handle_substitution(away_lineup, play.player_1_id.to_s, play.player_2_id.to_s)

          if away_lineup_result == nil
            game.update(redo_lineups: true)
            p 'Not a lineup of 5 or duplicate player'
            break
          end

          away_lineup = away_lineup_result
        else
          game.update!(redo_lineups: true)
          p 'not in lineups'
          break
        end
      elsif play.event_msg_type == 12 && play.period != 1
        season = ::Helpers::SeasonHelper.season_finder(game.date)
        starters = ::NBAApi::StatLineGrab.new(game.date, season, 'Regular%20Season').get_quarter_starters(play.period, game)
        if starters == false || starters[:home].length != 5 || starters[:home].uniq.count < 5 || starters[:away].length != 5 || starters[:away].uniq.count < 5
          game.update!(redo_lineups: true)
          p 'catch all error'
          break
        end
        home_lineup = Lineup.create_lineup(starters[:home])
        away_lineup = Lineup.create_lineup(starters[:away])
      end

      play.update_attributes(home_lineup_id: home_lineup.id, away_lineup_id: away_lineup.id)
    end

    p "done with game #{game.nba_id}"
  end

  private

  def handle_substitution(lineup, subbee, subber)
    new_player_array = lineup.replace_player(subbee, subber)
    return nil if new_player_array.length < 5
    if new_player_array.length != 5 || new_player_array.uniq.count < 5
        return nil
    end
    Lineup.create_lineup(new_player_array)
  end

  def parsed_dates(start_date, end_date)
    start = Date.parse(start_date)
    endd = end_date ? Date.parse(end_date) : start
    season = ::Helpers::SeasonHelper.season_finder(start)

    [start, endd]
  end
end
