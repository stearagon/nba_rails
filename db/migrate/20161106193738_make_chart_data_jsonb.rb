class MakeChartDataJsonb < ActiveRecord::Migration[5.0]
  def change
    remove_column :charts, :data
    add_column :charts, :data, :jsonb
  end
end
