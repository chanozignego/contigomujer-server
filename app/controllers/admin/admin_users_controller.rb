module Admin
  class AdminUsersController < Admin::ApplicationController
    include ChangePasswordMethods

    def create
      params[:admin_user][:password] = "contigo123" #TODO: autogenerate password
      params[:admin_user][:password_confirmation] = "contigo123" #TODO: autogenerate password
      if params[:admin_user][:superadmin]

      end

      resource = resource_class.new(resource_params)

      if resource.save
        unless resource.superadmin?
          aux = Auxiliary.new(name: resource.name, 
                              phone: resource.phone, 
                              email: resource.email, 
                              town: resource.town, 
                              admin_user: resource, 
                              password: params[:admin_user][:password],
                              password_confirmation: params[:admin_user][:password])
          aux.save
        end
        redirect_to(
          admin_admin_user_path(resource),
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource)
        }
      end
    end

    private 

      def render_update_password_success
        aux = Auxiliary.where(admin_user_id: @resource.id).first
        aux.update_attributes(password: params[:admin_user][:password], 
                              password_confirmation: params[:admin_user][:password_confirmation]) if aux.present?
        super
      end

      def permitted_attributes
        permitted = dashboard.permitted_attributes
        permitted << :password
        permitted << :password_confirmation
        permitted
      end
  end
end
