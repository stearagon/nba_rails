class DefaultDashbaord1 < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :default_dashboard_id, :integer, default: 1
  end
end
