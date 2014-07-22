load 'admin/base_admin_controller.rb'

module Admin
  class VideosController < Admin::BaseController
    before_filter :load_video, :only => [:edit, :approve, :show]

    def index
      params[:q] ||= {}
      page = params[:page] || 1
      search_params = params[:q]
      search_params.delete(:approved_eq) if search_params[:approved_eq].blank?

      @user = User.find_by_id(params[:user_id]) unless params[:user_id].blank?
      if @user.nil?
        @q = Video.includes(:user).search(search_params)
      else
        @q = @user.videos.includes(:user).search(search_params)
      end
      @q.sorts = 'created_at desc' if @q.sorts.empty?
      @videos = @q.result(distinct: true).page(page).per(15)
    end

    def show
      redirect_to edit_admin_video_path(@video)
    end

    def approve
      @video.update_attribute(:approved, true)
      render :json => { :message => t(:video_approved, :name => @video.name) }, :status => 200
    end

    private

    def load_video
      id = params[:video_id] || params[:id]
      @video = Video.includes(:user_votes).find_by_id(id)

      if @video.nil?
        error_text = t('errors.videos.not_found')
        respond_to do |format|
          format.html do
            flash[:alert] = error_text
            redirect_to admin_videos_path
          end
          format.json do
            render :json => { :error => error_text }.to_json, :status => 500
          end
        end
      end
    end
  end
end
