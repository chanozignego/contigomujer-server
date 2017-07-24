module Administrate
  module PictureHelper
    def render_responsive_clearfix form_instance
      return capture_haml do
        if form_instance.options[:child_index] != 0
          if form_instance.options[:child_index] - 1 % 4 == 0 
            haml_tag :div, class: "visible-lg clearfix"
          end
          if form_instance.options[:child_index] - 1 % 2 == 0
            haml_tag :div, class: "visible-md cleafix"
          end
        end
        haml_tag :div, class: "visible-xs clearfix"

      
      end
    end
  end
end