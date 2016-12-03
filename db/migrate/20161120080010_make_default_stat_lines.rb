class MakeDefaultStatLines < ActiveRecord::Migration[5.0]
  def change
    change_column :stat_lines, :fgm, :integer, default: 0
    change_column :stat_lines, :fga, :integer, default: 0
    change_column :stat_lines, :fg3m, :integer, default: 0
    change_column :stat_lines, :fg3a, :integer, default: 0
    change_column :stat_lines, :ftm, :integer, default: 0
    change_column :stat_lines, :fta, :integer, default: 0
  end
end
