module Games
  class FiveCrowns
    # Returns the score for the player who finished first (0 for Five Crowns)
    def self.finished_first_score
      0
    end
    def self.initial_data(players)
      {
        "game_type" => "five_crowns",
        "players" => players,
        "current_round" => 1,
        "max_rounds" => 11,
        "total_scores" => players.to_h { |player| [player, 0] },
        "round_details" => (1..11).map { |round|
          { "round" => round, "cards" => round + 2 }
        }
      }
    end

    def self.cards_for_round(round_number)
      round_number + 2
    end

    def self.wild_cards(round_number)
      if round_number <= 8
        "#{round_number + 2}"
      else
        case round_number
        when 9
          "Jack"
        when 10
          "Queen"
        when 11
          "King"
        end
      end
    end

    def self.is_game_complete?(current_round)
      current_round > 11
    end

    def self.calculate_totals(score_sheet)
      # Logic to sum up all rounds for each player
      totals = score_sheet.data["players"].map { |p| [p, 0] }.to_h

      score_sheet.rounds.each do |round|
        round.data["scores"]&.each do |player, score|
          totals[player] += score.to_i
        end
      end

      totals
    end

    def self.create_round_data(score_sheet)
      {
        "round_number" => score_sheet.rounds.count + 1,
        "scores" => score_sheet.session_players.map { |p| [p.user.username, nil] }.to_h,
        "status" => "in_progress"
      }
    end

    def self.max_players
      7
    end

    def self.min_players
      2
    end
  end
end
