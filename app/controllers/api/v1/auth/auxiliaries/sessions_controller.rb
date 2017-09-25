module Api
  module V1
    module Auth
      module Auxiliaries
        class SessionsController < Api::Auth::SessionsController
          
          resource_description do
            name "Auxiliaries/Sessions"
          end

          api :POST, '/v1/auth/auxiliaries/sign_in', "Login user"
          param :email, String, required: true      
          param :password, String, required: true      
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def create
            super
          end

          api :DELETE, '/v1/auth/auxiliaries/sign_out', "Logout user"
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def destroy
            super
          end

          protected
            def set_resource
              @resource = current_auxiliary
              # if request.headers["id"].present?
              #   @resource = User.find(request.headers["id"])
              # end
            end
        
            def render_create_success
              #update_device_token
              render json: @resource, status: :ok
            end

            def render_create_error
              render json: {message: "could not find user"}, status: :unprocessable_entity
            end

        end
      end
    end
  end
end
