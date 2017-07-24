require "administrate/fields/base"

module Administrate
  module Field
    class Password < Field::Base
      def to_s
        "***"
      end
    end
  end
end
