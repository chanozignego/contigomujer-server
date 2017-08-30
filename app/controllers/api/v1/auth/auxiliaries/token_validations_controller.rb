module Api
  module V1
    module Auth
      module Auxiliaries
        class TokenValidationsController < Api::Auth::TokenValidationsController

          def validate_token
            # @resource will have been set by set_user_token concern
            if @resource
              render_validate_token_success
            else
              render_validate_token_error
            end
          end

          protected
            def render_validate_token_success
              render json: {
                success: true,
                data: resource_data(resource_json: @resource)
              }
            end

        end
      end
    end
  end
end
