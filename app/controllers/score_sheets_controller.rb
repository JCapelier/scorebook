class ScoreSheetsController < ApplicationController

  def create
    @session = GameSession.find(params[:score_sheet][:game_session_id])
    @players = @session.session_players.map { |player| player.user.username }
    @game_service = "Games::#{@session.game.title.gsub(' ', '')}".constantize
    initial_data = @game_service.initial_data(@players)
    @score_sheet = ScoreSheet.new(
      game_session: @session,
      data: initial_data
    )
    if @score_sheet.save
      redirect_to score_sheet_path(@score_sheet)
    else
      redirect_to new_session_player_path(game_session_id: @session.id)
    end
  end

  def show
    @score_sheet = ScoreSheet.find(params[:id])
    @players = @score_sheet.session_players
    @game_service = "Games::#{@score_sheet.game_session.game.title.gsub(' ', '')}".constantize
  end
end
