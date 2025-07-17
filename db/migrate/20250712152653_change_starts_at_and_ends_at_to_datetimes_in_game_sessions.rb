class ChangeStartsAtAndEndsAtToDatetimesInGameSessions < ActiveRecord::Migration[8.0]
  def change
    change_column :game_sessions, :starts_at, :datetime
    change_column :game_sessions, :ends_at, :datetime
  end
end
