module SearchMethods
  extend ActiveSupport::Concern

  included do
    helper_method :search_attributes, :current_search

    def current_search
      "#{controllers_model_name}Search".safe_constantize
    end

    def search_attributes
      @search_attributes ||= search_params
    end

    private
      def controllers_model_name
        controller_name.singularize.camelize
      end

      def search_params
        p = params[:"#{controllers_model_name.underscore.downcase}_search"]
        p ? p : {}
      end


  end

end