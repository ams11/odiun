load 'admin/base_admin_controller.rb'

module Admin
  class UsersController < Admin::BaseController

    def index
      @users = User.all
    end

    def edit
      id = params[:user_id] || params[:id]
      @user = User.find_by_id(id)

      redirect_to admin_users_path if @user.nil?
    end

    def show
      id = params[:user_id] || params[:id]
      redirect_to edit_admin_user_path(id)
    end
  end
end