  # Returns the profile picture URL for a user, or the default if none is set
  def user_profile_pic_url(user)
    if user&.profile_pic&.attached?
      url_for(user.profile_pic)
    else
      "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg"
    end
  end
module ApplicationHelper

  def format_datetime(datetime)
    datetime.strftime('%d/%m/%Y %H:%M')
  end

end
