require "searchlight/adapters/action_view"

class InfoSearch < Searchlight::Search
  include Searchable::Base
  include Searchlight::Adapters::ActionView

end