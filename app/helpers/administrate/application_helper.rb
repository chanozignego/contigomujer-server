module Administrate
  module ApplicationHelper
    include CommonHelper
    include PictureHelper
    
    def render_field(field, locals = {})
      locals.merge!(field: field)
      render locals: locals, partial: field.to_partial_path
    end

    def display_resource_name(resource_name)
      resource_name.
        to_s.
        classify.
        constantize.
        model_name.
        human(
          count: 0,
          default: resource_name.to_s.pluralize.titleize,
        )
    end

    def active_property resource_type, property_type
      # return "active" if resource.actable_type == "Choice" && property_type.to_s == "Dropdown"
      # return resource.actable_type == property_type ? "active" : ""      
      resource_type == property_type ? "active" : ""
    end

    def namespace
      Administrate::NAMESPACE
    end

    def app 
     Rails.application
    end

    def pluralized_resource(field)
      field.data.class.to_s.downcase.pluralize
    end

    def singularized_resource(field)
      field.data.class.to_s.downcase.singularize
    end

    #
    # Form Helpers
    #
    def image_preview(form_instance, attr_symbol, size = :thumb)
      model_instance = form_instance.object

      if !model_instance.nil? && model_instance.send(attr_symbol).try(:file).try(:exists?)
        form_instance.template.image_tag(model_instance.send(attr_symbol).url(size))
      else
        form_instance.template.content_tag(:span, "")
      end
    end

    def nested_children_build(form_instance, children_symbol, sort_order=nil)
      form_instance.object.send(children_symbol).build if form_instance.present? && children_symbol.is_a?(Symbol) && form_instance.object.send(children_symbol).size == 0
      form_instance.object.send(children_symbol).order(sort_order) if sort_order.present? 
    end

  end
end