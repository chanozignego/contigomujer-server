require "administrate/fields/base"

module Administrate
  module Field
    class Enum < Field::Base

      # To use this field type, you need to have:
      # - a enum in your model, like this:
      #   #your_model.rb
      #   enum your_enum: { option1: 0, option2: 1, option3: 2 }
      #   
      # - translations for your options with this format:
      #   #your_model.es-AR.yml
      #   es-AR:
      #     your_enum_in_plural: 
      #       option1: Translation1
      #       option2: Translation2
      #       option3: Translation3

      def to_s
        data
      end
    end
  end
end