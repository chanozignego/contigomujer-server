require "searchlight/adapters/action_view"

class LawSearch < Searchlight::Search
  include Searchable::Base
  include Searchlight::Adapters::ActionView

end