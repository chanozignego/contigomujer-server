module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :null_session, only: :create

      # ParamError is superclass of ParamMissing, ParamInvalid
      rescue_from Apipie::ParamError do |e|
        render json: e.message, status: 400
      end

      def create
        params.delete(:registration)
        params[:address] = "#{params[:street]} #{params[:number]}, #{params[:apartment]}"
        super
      end

      protected

        def render_create_success
          update_device_token
          render json: @resource, status: :ok 
        end

        def update_device_token
          @resource.update({
            device_token: request.headers["device-token"]
          }) if request.headers["device-token"].present?
        end

    end
  end
end
