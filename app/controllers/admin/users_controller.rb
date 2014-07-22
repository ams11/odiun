load 'admin/base_admin_controller.rb'

module Admin
  class UsersController < Admin::BaseController

    def index
      params[:q] ||= {}
      page = params[:page] || 1
      search_params = params[:q]

      @q = User.includes(:videos).search(search_params)
      @q.sorts = 'email' if @q.sorts.empty?
      @users = @q.result(distinct: true).page(page).per(15)

      @ranks = []
      Rank.find_each do |rank|
        @ranks << [rank.name, rank.id, ((params[:q][:rank_id_eq].to_s rescue nil) == rank.id.to_s) ? { :selected => true } : {}]
      end
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