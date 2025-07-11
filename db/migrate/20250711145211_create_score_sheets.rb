class CreateScoreSheets < ActiveRecord::Migration[7.1]
  def change
    create_table :score_sheets do |t|
      t.references :game_session, null: false, foreign_key: true
      t.jsonb :data

      t.timestamps
    end
  end
end
