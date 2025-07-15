class RoundsController < ApplicationController
  def create
    @score_sheet = ScoreSheet.find(params[:score_sheet_id])
    game_service = "Games::#{@score_sheet.game_session.game.title.gsub(' ', '')}".constantize
    round_data = game_service.create_round_data(@score_sheet)
    @round = Round.new(score_sheet: @score_sheet, data: round_data)
    if @round.save
      redirect_to score_sheet_path(@score_sheet)
    else
      redirect_to score_sheet_path(@score_sheet), alert: "Failed to create round"
    end
  end

  def edit
    @round = Round.find(params[:id])
  end
  def update
    @round = Round.find(params[:id])
    updated_data = @round.data.dup
    updated_data["scores"] = params[:scores]
    updated_data["status"] = "completed"
    if @round.update(data: updated_data)
      new_totals = @round.game_service.calculate_totals(@round.score_sheet)
      score_sheet_data = @round.score_sheet.data.dup
      score_sheet_data["total_scores"] = new_totals
      current_round = score_sheet_data["current_round"]
      unless @round.game_service.is_game_complete?(current_round + 1)
        score_sheet_data["current_round"] += 1
      else

        score_sheet_data["game_status"] = "completed" 
      end
      @round.score_sheet.update(data: score_sheet_data)
      redirect_to score_sheet_path(@round.score_sheet)
    else
      render :edit
    end
  end
end
