class SessionPlayersController < ApplicationController
  def new
    @session_player = SessionPlayer.new
    @session = GameSession.find(params[:game_session_id])
    @score_sheet = ScoreSheet.new
  end

  def create
    @score_sheet = ScoreSheet.new
    @session = GameSession.find(params[:session_player][:game_session_id])
    @session_player = SessionPlayer.new(
      user: User.find_by(username: session_player_params[:user]),
      game_session: @session,
      position: session_player_params[:position]
    )
    if @session_player.save
      redirect_to new_session_player_path(game_session_id: @session.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def session_player_params
    params.require(:session_player).permit(:user, :position, :game_session_id)
  end
end
