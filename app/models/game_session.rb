class GameSession < ApplicationRecord
  belongs_to :game
  has_many :session_players, dependent: :destroy
  has_one :score_sheet, dependent: :destroy
end
