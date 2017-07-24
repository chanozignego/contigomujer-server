module CommonHelper

  def notify_type_for_flash flash_type
    types = {notice: :success, alert: :warning, error: :danger}.with_indifferent_access
    types[flash_type].presence || :info
  end
  
  def active_sidebar name
    (params[:active_sidebar].to_s == name.to_s || controller_name.to_s == name.to_s) ? :active : "" 
  end

  def is_property_type? type
    Property::TYPES.include?(type.to_s)
  end

  def is_choice_type? type
    Choice::TYPES.include?(type.to_s)
  end

  def object_class entity
    return unless entity.present?
    entity.is_a?(Draper::Decorator) ? entity.object.class : entity.class    
  end

  def submit_entity_label entity, options={}
    options = options.with_indifferent_access
    key = entity.new_record? ? "administrate.actions.create_entity" : "administrate.actions.update_entity"
    entity_name = options[:entity_name].presence || entity.class.model_name.human
    I18n.t(key, entity: entity_name)
  end

  def breadcrumb_title model
    resource = model.find(params[:id]) if params[:id]
    name_present = resource.present? && resource.respond_to?(:name)
    parameters = {entity: model.model_name.human}
    parameters.merge!({name: resource.name}) if name_present
    case action_name
      when "edit", "update"
        I18n.t("administrate.actions.#{name_present ? "edit_entity_breadcrumb" : "edit_entity"}", parameters )
      when "new", "create"
        I18n.t("administrate.actions.#{name_present ? "new_entity_breadcrumb" : "new_entity"}",  parameters )
      when "show"
        I18n.t("administrate.actions.#{name_present ? "show_entity_breadcrumb" : "show_entity"}", parameters )    
      else
        model.model_name.human
    end
  end

end