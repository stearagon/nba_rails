class Api::DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :charts
end
