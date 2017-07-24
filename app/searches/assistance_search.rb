require "searchlight/adapters/action_view"

class AssistanceSearch < Searchlight::Search
  include Searchable::Base
  include Searchlight::Adapters::ActionView

end