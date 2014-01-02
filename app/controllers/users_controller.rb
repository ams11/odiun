include ApplicationHelper

class UsersController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => [:dashboard, :vote]
  before_filter :load_and_verify_user, :only => [:dashboard, :vote]

  def dashboard
    @videos = @user.videos.limit(6)
  end

  def vote
    @videos = @user.vote_videos
  end

  private

  def load_user
    id = params[:user_id] || params[:id]
    @user = User.where(:id => id).includes(:videos)[0]

    error = t('errors.users.not_found')

    if @user.nil?
      respond_to do |format|
        format.html do
          flash[:alert] = error
          redirect_to root_path
        end
        format.json do
          render :json => { :message => error }.to_json, :status => 500
        end
      end
    end
  end

  def load_and_verify_user
    load_user
    unless @user.nil?
      if (@user != current_user && !current_user.admin?)
        flash[:alert] = t('errors.users.cant_see')
        redirect_to root_path
      elsif !@user.voter? && !current_user.admin?
        flash[:alert] = t('errors.users.cant_vote')
        redirect_to edit_user_registration_path
      end
    end
  end
end