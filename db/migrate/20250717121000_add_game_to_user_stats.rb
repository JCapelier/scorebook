class AddGameToUserStats < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_stats, :game, null: false, foreign_key: true
    add_index :user_stats, [:user_id, :game_id], unique: true
  end
end
