class MovesController < ApplicationController
  def create
    @player = SessionPlayer.find(params[:session_player_id])
    @round = Round.find(params[:round_id])
    @move_type = params[:move_type]
    @move = Move.create(
      session_player: @player,
      round: @round,
      move_type: @move_type
    )

    if @move.persisted?
      redirect_to edit_round_path(@round)
    else
      redirect_to score_sheet_path(@round.score_sheet), alert: "Failed to create round"
    end
  end
end
