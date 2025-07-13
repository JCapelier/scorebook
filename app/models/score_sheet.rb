class ScoreSheet < ApplicationRecord
  belongs_to :game_session
  has_many :rounds, dependent: :destroy
end
