module Admin
  class BaseController < ApplicationController
    before_filter :authenticate_user!
    before_filter :check_for_active_admin_user

    layout 'admin'

    private

    def check_for_active_admin_user
      if current_user.nil?
        error_text = t('errors.users.must_sign_in')
        redirect_path = new_user_session_path
      elsif !current_user.admin?
        error_text = t('errors.users.admin')
        redirect_path root_path
      else
        error_text = redirect_path = nil
      end

      unless error_text.nil?
        respond_to do |format|
          format.html do
            flash[:alert] = error_text
            redirect_path = root_path if redirect_path.nil?
            redirect_to redirect_path
          end
          format.json do
            render :json => { :error => error_text }.to_json, :status => 500
          end
        end
      end
    end
  end
end