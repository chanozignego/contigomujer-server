require "searchlight/adapters/action_view"

class AdminUserSearch < Searchlight::Search
  include Searchable::Base
  include Searchlight::Adapters::ActionView

end