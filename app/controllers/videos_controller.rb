include VideosHelper

class VideosController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => [:new, :create, :update, :destroy, :toggle_feature]
  before_filter :load_video, :only => [:edit, :show, :update, :destroy, :toggle_feature, :vote]
  before_filter :get_genres, :only => [:new, :edit]
  after_filter  :update_personal_content_ratings, :only => :create
  after_filter  :create_user_vote, :only => :vote

  def new
    @video = Video.new
  end

  def get_genres
    @genres_collection = Genre.all.collect { |genre| [genre.name, genre.id] }
  end

  def show
    if @video.nil?
      flash[:alert] = t('errors.videos.not_found')
      redirect_to videos_url and return
    else
      @video_score = (@video.get_score * 100).round
      if current_user
        user_vote = UserVote.where(:user => current_user, :video => @video).limit(1).first
        @user_score = user_vote.score unless user_vote.nil?
      end
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
    old_values = { :score_total => @video.score_total, :max_score => @video.max_score }

    success = false
    if current_user.voter?
      params[:video] ||= {}
      new_score = params[:video][:score]
      if valid_score(new_score)
        @video.update_vote new_score.to_d / 10, current_user
        success = @video.valid?
      end
    end

    if success
      redirect_to video_path(@video)
    else
      @video.score_total = old_values[:score_total]
      @video.max_score = old_values[:max_score]
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
    @videos = Video.all.order(:max_score).limit(8)
    @featured_vids = Video.featured.order(:max_score).limit(8)
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

  protected

  def valid_score score_value
    return false if score_value.nil?
    score_value.to_d.between?(0.0, 100.0)
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

  def update_personal_content_ratings
    if @video && @video.valid? && current_user
      current_user.update_ratings UserGenreScore::PERSONAL, @video.genre, current_user.videos.count
    end
  end

  def create_user_vote
    params[:video] ||= {}
    new_score = params[:video][:score]
    if @video && @video.valid? && current_user && new_score
      user_vote = UserVote.where(:user => current_user, :video => @video).limit(1).first
      if user_vote.nil?
        UserVote.create(:user => current_user, :video => @video, :score => new_score.to_d)
      else
        user_vote.update_attribute(:score, new_score.to_d)
      end
    end
  end
end