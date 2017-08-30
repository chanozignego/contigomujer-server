module Api
  module Auth
    class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
      protect_from_forgery with: :null_session, only: :create

      # ParamError is superclass of ParamMissing, ParamInvalid
      rescue_from Apipie::ParamError do |e|
        render json: e.message, status: 400
      end

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
          data: resource_data(resource_json: @resource.token_validation_response)
        }
      end

      def render_validate_token_error
        render json: {
          success: false,
          errors: [I18n.t("devise_token_auth.token_validations.invalid")]
        }, status: 401
      end
    end


  end
end
