module Admin
  class ApplicationController < Administrate::ApplicationController
    include Authorizable
    include SearchMethods
    include Sortable
    include MassAssignmentLogic

    prepend_before_filter :authenticate_admin_user!
    helper_method :current_dashboard

    def current_dashboard
      "#{controllers_model_name}Dashboard".safe_constantize
    end

    #
    # Default Actions
    #
    def index
      resources = _search.try(:results) || scoped_collection
      resources = order.apply(resources).page(params[:page]).per(records_per_page).decorate
      page      = Administrate::Page::Collection.new(dashboard, order: order)
      render locals: { resources: resources, search_term: "", page: page, search: _search }
    end

    def _search
      scope_and_search_params = {scope: scoped_collection}.with_indifferent_access.merge(search_params)
      search    = current_search.new(scope_and_search_params) rescue nil
    end

    def show
      render locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource.try(:decorate)),
      }
    end

    # def authenticate_admin_user!
    #   binding.pry
    #   super
    # end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
    private

      def permitted_attributes
        dashboard.permitted_attributes
      end

      def scoped_collection
        klass = resource_resolver.resource_class
        respond_to?(:policy_scope) ? policy_scope(klass) : klass.all
      end

      alias_method :mass_assignment_scope, :scoped_collection #Doing this the mass assignment scope is equal to the scope shown in the index

  end
end
