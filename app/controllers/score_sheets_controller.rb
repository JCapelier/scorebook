class ScoreSheetsController < ApplicationController

  def first_player
    @score_sheet = ScoreSheet.find(params[:id])
    @score_sheet.data["first_player"] = params[:first_player]
    @score_sheet.save!
    head :ok
  end

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
      @score_sheet.reload
      max_rounds = initial_data["max_rounds"]
      created = 0
      max_rounds.times do |i|
        round_data = @game_service.create_round_data(@score_sheet).merge("round_number" => i + 1)
        round = Round.create!(score_sheet_id: @score_sheet.id, data: round_data)
        Rails.logger.error "Round errors: #{round.errors.full_messages.join(', ')}" unless round.persisted?
        created += 1 if round.persisted?
      end
      unless created == max_rounds
        Rails.logger.error "Expected to create #{max_rounds} rounds, but only created #{created}"
        raise "Failed to create all rounds"
      end
      redirect_to score_sheet_path(@score_sheet)
    else
      Rails.logger.error "ScoreSheet failed to save: #{@score_sheet.errors.full_messages.join(', ')}"
      raise "ScoreSheet failed to save: #{@score_sheet.errors.full_messages.join(', ')}"
    end
  end

  def show
    @score_sheet = ScoreSheet.find(params[:id])
    @players = @score_sheet.session_players
    @game_service = "Games::#{@score_sheet.game_session.game.title.gsub(' ', '')}".constantize
  end
  # POST /score_sheets/:id/end_game
  def end_game

    @score_sheet = ScoreSheet.find(params[:id])
    @score_sheet.data["game_status"] = "completed"
    @score_sheet.save!
    # Set ends_at on the game session if not already set
    if @score_sheet.game_session.ends_at.nil?
      @score_sheet.game_session.ends_at = Time.current
      @score_sheet.game_session.save!
    end

    # Calculate stats for this game
    stats = calculate_celebration_stats(@score_sheet)
    @score_sheet.data["celebration_stats"] = stats
    @score_sheet.save!

    # Update UserStat for each player
    @score_sheet.session_players.each do |session_player|
      user = session_player.user
      user_stat = UserStat.find_or_create_by(user: user, game: @score_sheet.game)
      user_stat.games_played += 1
      if stats[:ranking].first[:name] == user.username
        user_stat.games_won += 1
      end
      # Update highest round score
      user_high = stats[:highest_scores][user.username] || 0
      user_stat.highest_round_score = [user_stat.highest_round_score, user_high].max
      # Update longest zero streak
      # Only update longest_zero_streak for Five Crowns
      if @score_sheet.game.title.downcase.include?("five crowns")
        user_streak = stats[:zero_streaks][user.username] || 0
        user_stat.longest_zero_streak = [user_stat.longest_zero_streak, user_streak].max
      end
      user_stat.save!
    end

    redirect_to results_score_sheet_path(@score_sheet), allow_other_host: false, status: :see_other
  end

  # GET /score_sheets/:id/results
  def results
    @score_sheet = ScoreSheet.find(params[:id])
    stats = @score_sheet.data["celebration_stats"]
    if stats.is_a?(String)
      stats = JSON.parse(stats)
    end
    if stats.nil?
      stats = calculate_celebration_stats(@score_sheet)
      @score_sheet.data["celebration_stats"] = stats
      @score_sheet.save!
    end
    @celebration_stats = stats.deep_symbolize_keys
    @players = @score_sheet.session_players
    @game_service = "Games::#{@score_sheet.game_session.game.title.gsub(' ', '')}".constantize
  end

  private

  # Returns a hash of stats for the celebration/results page
  def calculate_celebration_stats(score_sheet)
    players = score_sheet.session_players.map { |p| p.user.username }
    total_scores = score_sheet.data["total_scores"] || {}
    if score_sheet.game.title.downcase.include?("five crowns")
      ranking = players.map { |name| { name: name, score: total_scores[name] || 0 } }.sort_by { |h| h[:score] }
    else
      ranking = players.map { |name| { name: name, score: total_scores[name] || 0 } }.sort_by { |h| -h[:score] }
    end

    # Most first finishes
    first_finishes = Hash.new(0)
    score_sheet.rounds.each do |r|
      if r.data["finished_first"].present?
        first_finishes[r.data["finished_first"]] += 1
      end
    end
    most_first = first_finishes.max_by { |_, v| v }
    most_first = { name: most_first&.first || players.first, count: most_first&.last || 0 }

    # Highest single round per player
    highest_scores = Hash.new(0)
    score_sheet.rounds.each do |r|
      if r.data["scores"].present?
        r.data["scores"].each do |name, score|
          score = score.to_i
          highest_scores[name] = [highest_scores[name], score].max
        end
      end
    end
    highest_score = highest_scores.max_by { |_, v| v }
    highest_score = { name: highest_score&.first || players.first, score: highest_score&.last || 0 }

    # Most 0s in a row per player
    zero_streaks = {}
    players.each do |name|
      max_streak = 0
      current = 0
      score_sheet.rounds.each do |r|
        if r.data["scores"].present? && r.data["scores"][name].to_i == 0
          current += 1
          max_streak = [max_streak, current].max
        else
          current = 0
        end
      end
      zero_streaks[name] = max_streak
    end
    most_zeros = zero_streaks.max_by { |_, v| v }
    most_zeros = { name: most_zeros&.first || players.first, count: most_zeros&.last || 0 }

    {
      ranking: ranking,
      most_first: most_first,
      highest_score: highest_score,
      most_zeros: most_zeros,
      highest_scores: highest_scores,
      zero_streaks: zero_streaks
    }
  end
end
