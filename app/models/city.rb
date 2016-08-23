# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  season     :string           not null
#  name       :string           not null
#  team_id    :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
end
