class Api::StatLineSerializer < ActiveModel::Serializer
  attributes :value, :date, :team_id, :game_id

  def id
    "#{object.reg_team_id}-#{object.reg_game_id}"
  end

  def value
    object.value
  end

  def date
    object.date
  end

  def team_id
    object.reg_team_id
  end

  def game_id
    object.reg_game_id
  end
end
