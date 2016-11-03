class UserDashboardJoin < ActiveRecord::Migration[5.0]
  def change
      create_table :dashboards_users, id: false do |t|
          t.integer :user_id, null: false
          t.integer :dashboard_id, null: false

          t.timestamps
      end
  end
end
