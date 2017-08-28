module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session, only: :create

      # def destroy
      #   set_resource
      #   super
      #   # if @resource.present? 
      #   #   render_destroy_success
      #   # else
      #   #   render_destroy_error
      #   # end
      # end

      def destroy
        # remove auth instance variables so that after_action does not run
        user = remove_instance_variable(:@resource) if @resource
        client_id = remove_instance_variable(:@client_id) if @client_id
        remove_instance_variable(:@token) if @token

        if user && client_id && user.tokens[client_id]
          user.tokens.delete(client_id)
          destroy_device_token(user)
          user.save!

          yield user if block_given?

          render_destroy_success
        else
          render_destroy_error
        end
      end

      # ParamError is superclass of ParamMissing, ParamInvalid
      rescue_from Apipie::ParamError do |e|
        render json: e.message, status: 400
      end

      protected
        def set_resource
          raise "Resource not found"
        end

        def render_destroy_success
          #destroy_device_token
          render json: {success: true}, status: :ok
        end

        def render_create_success
          update_device_token
          render json: @resource, status: :ok
        end

        def update_device_token
          @resource.update({
            device_token: request.headers["device-token"]
          }) if request.headers["device-token"].present?
        end

        def destroy_device_token resource
          resource.device_token = nil
        end
    end
  end
end
