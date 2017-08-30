module Api
  module V1
    class TownsController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

    end
  end
end
