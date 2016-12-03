# == Schema Information
#
# Table name: charts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :jsonb
#

require 'rails_helper'

RSpec.describe Chart, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
