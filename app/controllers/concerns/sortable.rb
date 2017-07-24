module Sortable
  extend ActiveSupport::Concern

  included do
    
    helper_method :sort_link, :sort_direction_class

    def sort_link attributes = [], args= {}
      args        = args.with_indifferent_access
      sort_elements = sort_fields_array(attributes)
      url = args[:path].presence || base_url
      url += (url[-1] == "?") ? "" : "&"
      sort = {sort: sort_elements }.to_param
      url + sort    
    end

    # it can receive the sort field or the direcion you want
    # if the direction is received then it returns the sort class for that direction
    # if the sort field is 
    def sort_direction_class options = {}
      options     = options.with_indifferent_access
      attribute   = (order.attributes.presence || params[:sort].presence || []).find {|x| x[:field]== options[:field].to_s} || {}
      direction   = options[:direction].presence || attribute[:direction]
      return "" if direction.blank?
      return "fa fa-sort-up"    if [:asc,  :up].include?(direction.to_s.downcase.to_sym)
      return "fa fa-sort-down"  if [:desc, :down].include?(direction.to_s.downcase.to_sym)
    end
    
    private
      def opposite_direction direction
        direction.to_s.downcase == "asc" ? "desc" : "asc"      
      end

      # Generates the array with the correct direction for each attribute
      # each element of the array has the following structure
      # {
      #   field: sort field name
      #   direction: asc or desc. if empty then generates the opposite direction based on the direction
      #   received by params[:sort] 
      # }
      #
      #
      def sort_fields_array attributes = [], args = {}
        args        = args.with_indifferent_access
        attributes  = attributes.reject{|x| x.compact.blank?}.map{|prop| prop.with_indifferent_access }
        actual_sort = args[:sort].presence || params[:sort].presence || []
        attributes.map do |attribute|
          actual_direction = actual_sort.find { |element| element[:field].to_s == attribute[:field].to_s }.try(:with_indifferent_access).try(:[], :direction)
          {field: attribute[:field].to_s, direction: attribute[:direction] || opposite_direction(actual_direction) }.with_indifferent_access
        end
      end

      def base_url
        request.env["PATH_INFO"] + "?" + params.reject{|x| ["controller", "action", "sort"].include?(x) }.to_param
      end


      def order
        @_order ||= Administrate::Order.new(params[:sort])
      end


  end

end