load 'admin/base_admin_controller.rb'

module Admin
  class UsersController < Admin::BaseController

    def index
      @users = User.all
    end
  end
end