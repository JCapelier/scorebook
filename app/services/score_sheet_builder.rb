class ScoreSheetBuilder
  def self.build_for_session(session)
    players = session.session_players.map { |player| player.user.username }
    game_service = "Games::#{session.game.title.gsub(' ', '')}".constantize
    initial_data = game_service.initial_data(players)
    score_sheet = ScoreSheet.create(game_session: session, data: initial_data)
    if score_sheet.persisted? && initial_data["max_rounds"]
      max_rounds = initial_data["max_rounds"]
      max_rounds.times do |i|
        round_data = game_service.create_round_data(score_sheet).merge("round_number" => i + 1)
        Round.create!(score_sheet_id: score_sheet.id, data: round_data)
      end
    end
    score_sheet
  end
end
