module Api
  module V1
    class LawsController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

    end
  end
end
