module VideosHelper
  def user_has_owner_privileges?(user)
    (user == current_user) || current_user.admin?
  end

  def user_can_vote? user
    user && user.rank && user.rank.rank > 0
  end

  def user_can_comment? user
    user
  end
end