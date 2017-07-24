module Admin
  class AdminUsersController < Admin::ApplicationController
    include ChangePasswordMethods

    def create
      params[:admin_user][:password] = "contigo123" #TODO: autogenerate password
      params[:admin_user][:password_confirmation] = "contigo123" #TODO: autogenerate password
      super
    end

    private 
      def permitted_attributes
        permitted = dashboard.permitted_attributes
        permitted << :password
        permitted << :password_confirmation
        permitted
      end
  end
end
