module Authorizable
  
  extend ActiveSupport::Concern

  included do
    include Pundit
    
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    before_action :authorize_action!, only: [:new, :show, :create, :update, :destroy, :edit, :index]

    private
      def user_not_authorized exception
        policy_name = exception.try(:policy).try(:class).to_s.underscore
        query = exception.try(:query).to_s
        flash[:error] = I18n.t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        redirect_to request.headers["Referer"] || root_path
      end

      def authorize_action!
        authorize(requested_resource) and return if params[:id].present? 
        if controllers_model_name.safe_constantize.present?
          authorize(resource_class.new)
        else
          authorize(controllers_model_name.underscore.to_s.to_sym, pundit_method)
        end
      end

      def pundit_method(action=nil)
        "#{(action.presence || action_name)}?".to_sym    
      end
      alias_method :pundit_user, :current_admin_user    

  end


end