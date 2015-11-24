class StatLineGrab
  def initialize(date, season, season_type)
    @date = date
    @season = season
    @season_type = season_type
  end

  def get_stat_lines
    games = Game.where(date: @date)

    games.each do |game|
      stat_line_json = HTTP.get(link_builder(game.nba_game_id)).parse
    end

    return "Done"
  end

  def link_builder(game_id)
    game = Game.find_by_nba_game_id(game_id)
    link = 'http://stats.nba.com/stats/boxscoretraditionalv2?EndPeriod=10&EndRange='
    link += game.quarters == 4 ? '28800' : ((game.quarters.to_i - 4 * 3000) + 28800).to_s
    link += '&GameID='
    link += game_id
    link += '&RangeType=0&Season='
    link += @season
    link += '&SeasonType='
    link += @season_type
    link += '&StartPeriod=1&StartRange=0'

    link
  end

  def grab_specific_referee_data(stats)
  end
end
