class Api::UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :dashboards
  has_one :default_dashboard
end
