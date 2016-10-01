class AddPbp < ActiveRecord::Migration[5.0]
  def change
    create_table :plays  do |t|
      t.string  :game_id, null: false
      t.integer  :event_num, null: false
      t.integer  :event_msg_type, null: false
      t.integer  :event_msg_action_type, null: false
      t.integer  :period, null: false
      t.string  :time, null: false
      t.string    :play_clock_time, null: false
      t.string  :home_description
      t.string  :neutral_description
      t.string  :visitor_description
      t.integer  :score
      t.integer  :score_margin
      t.integer  :player_1_type
      t.integer  :player_1_id
      t.integer  :player_1_team_id
      t.integer  :player_2_type
      t.integer  :player_2_id
      t.integer  :player_2_team_id
      t.integer  :player_3_type
      t.integer  :player_3_id
      t.integer  :player_3_team_id

      t.timestamps
    end

    add_index :plays, :game_id
    add_index :plays, [:game_id, :player_1_team_id]
    add_index :plays, [:game_id, :period]
  end
end
