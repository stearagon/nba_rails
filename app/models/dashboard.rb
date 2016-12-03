# == Schema Information
#
# Table name: dashboards
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#

class Dashboard < ApplicationRecord
    has_and_belongs_to_many :users
    has_and_belongs_to_many :charts
    has_many :default_users, class_name: 'User', foreign_key: 'default_dashboard_id', primary_key: :id
end
