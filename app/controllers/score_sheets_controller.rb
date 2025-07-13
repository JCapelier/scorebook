class ScoreSheetsController < ApplicationController

  def create
    @session = GameSession.find(params[:score_sheet][:game_session_id])
    @score_sheet = ScoreSheet.new(game_session: @session)
    if @score_sheet.save
      redirect_to score_sheet_path(@score_sheet)
    else
      redirect_to new_session_player_path(game_session_id: @session.id)
    end
  end

  def show
    @score_sheet = ScoreSheet.find(params[:id])
  end
end
