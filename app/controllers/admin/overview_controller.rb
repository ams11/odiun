load 'admin/base_admin_controller.rb'

module Admin
  class OverviewController < Admin::BaseController

    def index
      @videos_count = Video.count
      @approved_count = Video.approved.length
      @unapproved_count = Video.unapproved.length

      @users_count = User.count
    end
  end
end
