class AddDefaultDashboardToUsers < ActiveRecord::Migration[5.0]
  def change
      add_column :users, :default_dashboard_id, :integer
  end
end
