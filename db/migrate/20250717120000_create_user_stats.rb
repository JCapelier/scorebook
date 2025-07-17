class CreateUserStats < ActiveRecord::Migration[7.0]
  def change
    create_table :user_stats do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :games_played, default: 0, null: false
      t.integer :games_won, default: 0, null: false
      t.integer :highest_round_score, default: 0, null: false
      t.integer :longest_zero_streak, default: 0, null: false
      t.timestamps
    end
  end
end
