class GameSessionsController < ApplicationController
  def new
    @game = Game.find(params[:game_id])
    @session = GameSession.new
    @users = User.all

    @game.min_players.times { @session.session_players.build }
  end

  def build_player_field
    player = SessionPlayer.new
    render partial: "shared/new_player_form", locals: { player: player }
  end

  def create
    @game = Game.find(params[:game_id])
    @session = GameSession.new(game_session_params)
    @session.starts_at = DateTime.current
    @session.game = @game

    # Handle players from session[players][]
    if params[:session] && params[:session][:players]
      usernames = params[:session][:players].reject(&:blank?)
      @session.session_players = usernames.map do |username|
        user = User.find_by(username: username)
        SessionPlayer.new(user: user) if user
      end.compact
    end

    if @session.save
      @score_sheet = ScoreSheetBuilder.build_for_session(@session)
      redirect_to score_sheet_path(@score_sheet)
    else
      render :new
    end
  end

  private

  def game_session_params
    params.require(:game_session).permit(:place, session_players_attributes: [:user_id])
  end
end
