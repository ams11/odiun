include VideosHelper

class VideosController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => [:new, :create, :update, :destroy, :toggle_feature]
  before_filter :load_video, :only => [:edit, :show, :update, :destroy, :toggle_feature, :vote]
  before_filter :get_genres, :only => [:new, :edit]

  def new
    @video = Video.new
  end

  def get_genres
    @genres_collection = Genre.all.collect { |genre| [genre.name, genre.id] }
  end

  def show
    unless @video.present?
      flash[:alert] = t('errors.videos.not_found')
      redirect_to videos_url
    end
  end

  def create
    genre = Genre.find(params[:genre][:id]) rescue nil
    @video = Video.create_video(video_params, genre, current_user)

    if @video.nil?
      flash[:error] = t('errors.generic')
      redirect_to root_url
    elsif @video.errors.any?
      get_genres
      render :new
    else
      current_user.turn_into_voter!
      redirect_to user_dashboard_path(current_user)
    end
  end

  def update
    genre = Genre.find(params[:genre][:id]) rescue nil
    if @video.present?
      @video.update_video!(video_params, genre)
      if @video.errors.any?
        get_genres
        render :edit
      else
        flash[:notice] = "Video successfully updated"
        redirect_to user_dashboard_path(current_user)
      end
    end
  end

  def vote
    @video.score = params[:video][:score]
    @video.save
    if @video.valid?
      redirect_to video_path(@video)
    else
      render :show
    end
  end

  def destroy
    if @video.nil?
      render :json => t('errors.videos.not_found').to_json, :status => 500
    elsif !user_has_owner_privileges?(@video.user)
      render :json => t('errors.videos.other_user').to_json, :status => 500
    else
      Video.destroy @video
      render :json => "Success".to_json, :status => :ok
    end
  end

  def index
    @videos = Video.all.order(:score).limit(8)
    @featured_vids = Video.featured.order(:score).limit(8)
    if @featured_vids.count == 0
      @featured_vids = @videos.limit(8)
    end
    @genres = Genre.all
    @genres_last_index = @genres.count - 1
  end

  def toggle_feature
    if @video.nil?
      render :json => t('errors.videos.not_found').to_json, :status => 500
    else
      @video.update_attribute(:featured, !@video.featured)
      render :json => "Success".to_json, :status => :ok
    end
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end

  def load_video
    id = params[:video_id] || params[:id]
    @video = Video.find_by_id(id)

    if @video.nil?
      respond_to do |format|
        format.html { redirect_to videos_path }
        format.json { render :json => { :error => t('errors.videos.notfound') }.to_json, :status => 500 }
      end
    end
  end
end