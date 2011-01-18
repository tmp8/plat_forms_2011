module ApplicationHelper
  def login_navigation
    if current_user
      link_to("[Sign Out]", destroy_user_session_path)
    else
      link_to("[Sign In]", new_user_session_path) + link_to("[Register]", new_user_registration_path) 
    end
  end
  
  def user_info(user)
    if current_user && ((user == current_user) || (current_user.friend_state(user) == User::IN_CONTACT))
      "#{user.full_name} (#{user.email})"
    else
      "#{user.username}"
    end
  end
end
