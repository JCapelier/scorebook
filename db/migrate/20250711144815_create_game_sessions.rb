class CreateGameSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :game_sessions do |t|
      t.references :game, null: false, foreign_key: true
      t.date :starts_at
      t.date :ends_at
      t.string :place
      t.text :note

      t.timestamps
    end
  end
end
