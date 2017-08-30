module Api
  module V1
    class InfosController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

    end
  end
end
