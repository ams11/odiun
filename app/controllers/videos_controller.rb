include VideosHelper

class VideosController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => [:new, :create, :update, :destroy]
  before_filter :load_video, :only => [:edit, :show, :update, :destroy]

  def new
    @video = Video.new
  end

  def create
    @video = Video.create_video(video_params, current_user)

    if @video.nil?
      flash[:error] = t('errors.generic')
      redirect_to root_url
    elsif @video.errors.any?
      render :new
    else
      redirect_to video_url(@video)
    end
  end

  def update
    if @video.present?
      @video.update_video!(video_params)
      if @video.errors.any?
        render :edit
      else
        redirect_to video_url(@video)
      end
    end
  end

  def destroy
    if @video.nil?
      render :text => t('errors.videos.not_found'), :layout => false, :status => :error
    elsif !user_has_owner_privileges?(@video.user)
      render :text => t('errors.videos.other_user'), :layout => false, :status => :error
    else
      Video.destroy @video unless @video.nil?
      render :text => "", :layout => false
    end
  end

  def index
    @videos = Video.all
    featured_vids = Video.featured
    if featured_vids.count == 0
      @video = @videos[0]
    else
      @video = featured_vids[rand(0..(featured_vids.count-1))]
    end
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end

  def load_video
    @video = Video.find_by_id(params[:id])
  end
end