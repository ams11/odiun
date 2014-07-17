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

  def provider_logo provider, options = {}
    options.merge!(:class => "#{provider}_logo")
    return image_tag("youtube.png", options) if provider.to_sym == :youtube
    return image_tag("vimeo.png", options) if provider.to_sym == :vimeo
    ""
  end
end