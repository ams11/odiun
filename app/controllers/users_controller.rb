include ApplicationHelper

class UsersController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => :dashboard

  def dashboard
    id = params[:user_id] || params[:id]
    @user = User.where(:id => id).includes(:videos)[0]
    if @user.blank? || (@user != current_user && !current_user.admin?)
      flash[:alert] = t('errors.users.not_found')
      redirect_to root_url
    elsif !@user.voter?
      redirect_to edit_user_registration_path
    else

      @videos = current_user.videos
    end
  end
end