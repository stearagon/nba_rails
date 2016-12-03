class Api::GameSerializer < ActiveModel::Serializer
  attributes :id, :date

  has_one :away_team
  has_one :home_team
end
