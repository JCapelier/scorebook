class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_stat = @user.user_stat
    # Calculate total play time
    sessions = GameSession.joins(:session_players).where(session_players: { user_id: @user.id })
    @total_play_time = sessions.sum do |session|
      if session.starts_at && session.ends_at
        session.ends_at - session.starts_at
      else
        0
      end
    end

    # Games with at least one completed session for this user
    @completed_games = Game.joins(game_sessions: :session_players)
      .where(session_players: { user_id: @user.id })
      .where.not(game_sessions: { ends_at: nil })
      .distinct

    # Build detailed stats per game
    @game_stats = {}
    @completed_games.each do |game|
      sessions = game.game_sessions.joins(:session_players).where(session_players: { user_id: @user.id }).where.not(ends_at: nil)
      games_played = sessions.count
      time_played = sessions.sum { |s| (s.starts_at && s.ends_at) ? s.ends_at - s.starts_at : 0 }
      wins = 0
      losses = 0
      rounds_first = 0
      rounds_zero = 0
      longest_zero_streak = 0
      highest_score = 0
      sessions.each do |session|
        score_sheets = session.score_sheet ? [session.score_sheet] : []
        score_sheets.each do |sheet|
          # Ranking: lowest score wins for Five Crowns, highest for others
          total_scores = sheet.data["total_scores"] || {}
          user_score = total_scores[@user.username] || 0
          if game.title.downcase == "five crowns"
            min_score = total_scores.values.map(&:to_i).min
            max_score = total_scores.values.map(&:to_i).max
            wins += 1 if user_score.to_i == min_score
            losses += 1 if user_score.to_i == max_score
          else
            max_score = total_scores.values.map(&:to_i).max
            min_score = total_scores.values.map(&:to_i).min
            wins += 1 if user_score.to_i == max_score
            losses += 1 if user_score.to_i == min_score
          end
          # Rounds
          (sheet.rounds || []).each do |round|
            scores = round.data["scores"] || {}
            if round.data["finished_first"].to_s.strip.downcase == @user.username.to_s.strip.downcase
              rounds_first += 1
            end
            if scores[@user.username].to_i == 0
              rounds_zero += 1
              # Zero streak
              longest_zero_streak = [longest_zero_streak, (longest_zero_streak += 1)].max
            else
              longest_zero_streak = 0
            end
            highest_score = [highest_score, scores[@user.username].to_i].max
          end
        end
      end
      @game_stats[game.id] = {
        games_played: games_played,
        time_played: time_played,
        wins: wins,
        losses: losses,
        rounds_first: rounds_first,
        rounds_zero: rounds_zero,
        longest_zero_streak: longest_zero_streak,
        highest_score: highest_score
      }
    end
  end
end
