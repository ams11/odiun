module VideosHelper
  def user_has_owner_privileges?(user)
    (user == current_user) || current_user.admin?
  end
end