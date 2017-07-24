module MassAssignmentLogic
  extend ActiveSupport::Concern

  included do

    prepend_before_action :parse_params, only: :mass_assignment
    before_action :generate_batch_action_scope, only: :mass_assignment

    MAX_SINGLE_RECORDS_COUNT = 100

    def single_mass_assignment
      @scope.find_each do |entity|
        params[:args].present? ? entity.send(params[:method], params[:args]) : entity.send(params[:method])
        entity.save unless ["destroy", "destroy!"].include?(params[:method].to_s)
      end
      redirect_to :back, notice: I18n.t("mass_assignment.flash_messages.success")
    end

    def background_mass_assignment
      @response = BatchActionsHandler.instance.start_batch_action(params[:method].to_s, @scope, method_args: params[:args])
      flash_status = @response[:started] ? :notice : :error
      flash[flash_status] = @response[:message]
      redirect_to :back
    end


    # The controllers which include this module will expect to have a method named mass_assignment 
    # to handle the batch_actions. By default the batch_actions are executed at the moment the request come if
    # if the scope count is less or equal to MAX_SINGLE_RECORDS_COUNT.
    def mass_assignment
      @scope.count <= MAX_SINGLE_RECORDS_COUNT ? single_mass_assignment : background_mass_assignment
    end

    private
      
      def model_klass
        controller_name.singularize.camelize.constantize
      end

      def model_search_klass
        "#{model_klass.to_s}Search".constantize
      end

      def mass_assignment_scope
        model_klass.all
      end

      def parse_params
        params[:model_ids] = params[:model_ids].is_a?(Array) ? params[:model_ids] : params[:model_ids].split(",") unless params[:model_ids].blank?  
        params[:search]= JSON.parse(params[:search]).with_indifferent_access rescue params[:search] unless params[:search].blank?
      end

      def generate_batch_action_scope
        @scope = if ["1", "true", "on"].include?(params[:check_all].to_s.downcase) 
          scope_and_search_params = {scope: mass_assignment_scope}.with_indifferent_access.merge(params[:search])
          model_search_klass.new(scope_and_search_params).results
        else
          mass_assignment_scope.where(id: params[:model_ids])
        end
      end

  end

end