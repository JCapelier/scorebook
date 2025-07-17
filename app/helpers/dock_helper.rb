module DockHelper
  def dock_user_stats_path
    if current_user&.id
      user_stats_path(current_user.id)
    else
      root_path
    end
  end
end
