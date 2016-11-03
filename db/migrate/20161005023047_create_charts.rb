class CreateCharts < ActiveRecord::Migration[5.0]
  def change
    create_table :charts do |t|
      t.string :data, null: false

      t.timestamps
    end
  end
end
