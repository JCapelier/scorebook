class GameSessionsController < ApplicationController
  def new
    @game = Game.find(params[:game_id])
    @session = GameSession.new
  end

  def create
    @game = Game.find(params[:game_id])
    @session = GameSession.new(game_session_params)
    @session.starts_at = DateTime.current
    @session.game = @game
    if @session.save
      redirect_to new_session_player_path(game_session_id: @session.id)
    else
      render :new
    end
  end

  private

  def game_session_params
    params.require(:game_session).permit(:place)
  end
end
