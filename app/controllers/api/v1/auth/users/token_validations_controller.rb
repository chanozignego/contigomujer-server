module Api
  module V1
    module Auth
      module Users
        class TokenValidationsController < Api::Auth::TokenValidationsController

          protected
            def render_validate_token_success
              render json: {
                success: true,
                data: resource_data(resource_json: UserSerializer.new(@resource).to_hash)
              }
            end

        end
      end
    end
  end
end
