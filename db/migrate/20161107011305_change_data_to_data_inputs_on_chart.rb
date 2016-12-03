class ChangeDataToDataInputsOnChart < ActiveRecord::Migration[5.0]
  def change
    rename_column :charts, :data, :data_inputs
  end
end
