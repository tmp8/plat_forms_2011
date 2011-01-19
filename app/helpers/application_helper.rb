module ApplicationHelper
  def user_info(user)
    if current_user && ((user == current_user) || (current_user.friend_state(user) == User::IN_CONTACT))
      "#{user.full_name} ( #{user.email} )"
    else
      "#{user.username}"
    end
  end
end
