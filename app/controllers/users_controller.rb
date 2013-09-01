include ApplicationHelper

class UsersController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => :dashboard

  def dashboard
    @videos = current_user.videos
  end
end