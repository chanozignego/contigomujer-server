module Api
  module V1
    module Auth
      module Users
        class SessionsController < Api::Auth::SessionsController
          
          resource_description do
            name "Users/Sessions"
          end

          api :POST, '/v1/auth/users/sign_in', "Login user"
          param :email, String, required: true      
          param :password, String, required: true      
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def create
            super
          end

          api :DELETE, '/v1/auth/users/sign_out', "Logout user"
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def destroy
            super
          end

          #TODO: document
          def create_with_facebook
            if params[:uid].present?
              @resource = User.where(facebook_uid: params[:uid]).first
              if @resource.present? 

                @client_id = SecureRandom.urlsafe_base64(nil, false)
                @token     = SecureRandom.urlsafe_base64(nil, false)

                @resource.tokens[@client_id] = {
                  token: BCrypt::Password.create(@token),
                  expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
                }

                if @resource.save
                  new_auth_header = @resource.build_auth_header(@token, @client_id)
                  response.headers.merge!(new_auth_header)
                  render_create_success
                end
              else
                render_create_error
              end
            else 
              render_create_error
            end

          end

          protected
            def set_resource
              @resource = current_user
              # if request.headers["id"].present?
              #   @resource = User.find(request.headers["id"])
              # end
            end

            def render_create_error
              render json: {message: "could not find user"}, status: :unprocessable_entity
            end

        end
      end
    end
  end
end
