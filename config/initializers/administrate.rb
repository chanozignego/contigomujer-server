require "administrate/engine"
module Administrate

  class BaseDashboard
    include MassAssignmentable


    def self.model
      self.to_s.split("Dashboard").first.try(:constantize)
    end

  end

  class Order
    attr_accessor :attributes


    #
    # It receives an array of attributes. Each array element is a json with the following structure
    # {
    #    field: sort field used by sort.
    #    direction: asc or desc
    # }
    #
    def initialize(attributes = [])
      @attributes = (attributes || []).map(&:with_indifferent_access)
    end

    def apply(relation)
      order_query = attributes.map{|element| element[:field].to_s + ' ' + element[:direction].presence || 'asc' }.join(", ")
      relation.order(order_query)
    end

    def oposite_direction attribute
      actual_direction = (attributes.find { |prop| prop[:field].to_s == attribute.to_s } || {})[:direction].presence || ""
      actual_direction.to_s == "asc" ? "desc" : "asc"
    end

    def oposite_directions
      attributes.map { |attribute| self.oposite_direction(attribute) }
    end

  end

end