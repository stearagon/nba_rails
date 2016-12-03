# == Schema Information
#
# Table name: charts
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data_inputs :jsonb
#

class Chart < ApplicationRecord
    has_and_belongs_to_many :dashboards
end
