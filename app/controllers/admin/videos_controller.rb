load 'admin/base_admin_controller.rb'

module Admin
  class VideosController < Admin::BaseController

    def index
      @videos = Video.all
    end
  end
end
