module Admin
  class BaseController < ApplicationController
    before_filter :authenticate_user!
    before_filter :check_for_active_admin_user

    layout 'admin'

    private

    def check_for_active_admin_user
      if current_user.nil?
        flash[:alert] = t('errors.users.must_sign_in')
        redirect_to new_user_session_path
      elsif !current_user.admin?
        flash[:alert] = t('errors.users.admin')
        redirect_to root_path
      end
    end
  end
end