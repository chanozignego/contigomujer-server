require "searchlight/adapters/action_view"

class TownSearch < Searchlight::Search
  include Searchable::Base
  include Searchlight::Adapters::ActionView

end