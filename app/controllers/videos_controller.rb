class VideosController < ActionController::Base
  layout "application"

  before_filter :authenticate_user!, :only => [:new, :create]

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)

    redirect_to video_url(@video)
  end

  def show
    @video = Video.find(params[:id])
  end

  def index
    @videos = Video.all
  end

  private

  def video_params
    params.require(:video).permit(:url, :description)
  end
end