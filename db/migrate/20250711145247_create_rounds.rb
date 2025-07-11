class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :score_sheet, null: false, foreign_key: true
      t.jsonb :data

      t.timestamps
    end
  end
end
