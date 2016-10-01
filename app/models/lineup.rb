class Lineup < ActiveRecord::Base
  def self.create_lineup(players_array)
    raise 'Cannot have 6 players in array' if players_array.length > 5
    raise 'Cannot have 4 players in array' if players_array.length < 5
    raise 'Cannot have 2 of same player in array' if players_array.uniq.count < 5
    lineup_attrs = {
      player_1_id: players_array[0],
      player_2_id: players_array[1],
      player_3_id: players_array[2],
      player_4_id: players_array[3],
      player_5_id: players_array[4]
    }

    Lineup.find_or_create_by(lineup_attrs)
  end

  def players_array
    [
      player_1_id,
      player_2_id,
      player_3_id,
      player_4_id,
      player_5_id
    ]
  end

  def players_names
    players = []
    players_array.each do |id|
      players.push(Player.find_by(nba_id: id).name)
    end
    players
  end

  def replace_player(subbee, subber)
    p players_array
    p subbee
    p subber
    removed_player_array = players_array.tap { |a| a.delete(subbee) }
    p removed_player_array.push(subber).sort { |a,b| b<=>a }
  end
end
