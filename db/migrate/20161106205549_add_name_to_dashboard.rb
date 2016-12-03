class AddNameToDashboard < ActiveRecord::Migration[5.0]
  def change
    add_column :dashboards, :name, :string
  end
end
