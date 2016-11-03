class ChartsDashboards < ActiveRecord::Migration[5.0]
  def change
    create_table :charts_dashboards, id: false do |t|
        t.integer :chart_id, null: false
        t.integer :dashboard_id, null: false

        t.timestamps
    end
  end
end
