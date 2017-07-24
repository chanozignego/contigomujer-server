require "searchlight/adapters/action_view"

class UserSearch < Searchlight::Search
  include Searchable::Base
  include Searchlight::Adapters::ActionView

end