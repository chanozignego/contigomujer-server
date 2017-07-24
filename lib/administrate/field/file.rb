require "administrate/fields/base"

module Administrate
  module Field
    class File < Field::Base
      def to_s
        "***"
      end
    end
  end
end
