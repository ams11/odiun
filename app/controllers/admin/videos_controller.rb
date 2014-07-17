load 'admin/base_admin_controller.rb'

module Admin
  class VideosController < Admin::BaseController

    def index
      params[:q] ||= {}
      page = params[:page] || 1

      @q = Video.includes(:user).search(params[:q])
      @q.sorts = 'created_at desc' if @q.sorts.empty?
      @videos = @q.result(distinct: true).page(page).per(15)
    end

    def edit
      id = params[:video_id] || params[:id]
      @video = Video.find_by_id(id)

      redirect_to admin_videos_path if @video.nil?
    end

    def show
      id = params[:video_id] || params[:id]
      redirect_to edit_admin_video_path(id)
    end
  end
end
