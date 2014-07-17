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
  end
end
