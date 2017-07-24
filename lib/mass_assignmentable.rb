module MassAssignmentable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      const_set(:ALLOW_MASS_ASSIGNMENT, true)
      const_set(:MASS_ASSIGNMENT_ACTIONS, [destroy: {confirm: true}])
    end
  end

  class_methods do
  # it expects every action to be a hash
    def batch_actions
      mass_assignment_actions = Array("#{self}::MASS_ASSIGNMENT_ACTIONS".safe_constantize).first.presence || {}
      mass_assignment_actions.inject({}.with_indifferent_access) do |actions, (action_name, data)|
        actions.tap do 
          data = data.with_indifferent_access
          data[:confirm] = data[:confirm].to_s.downcase == "true" ? I18n.t("administrate.actions.confirm") : data[:confirm]
          actions[action_name] = data
        end
      end
    end
  end

end
