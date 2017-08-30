module Api
  module V1
    module Auth
      module Auxiliaries
        class RegistrationsController < Api::Auth::RegistrationsController

          resource_description do
            name "Users/Registrations"
          end

          api :POST, '/v1/auth/users', "Create user"
          param :name, String, required: true      
          param :email, String, required: true      
          param :password, String, required: true      
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def create
            params.delete(:registration)
            params[:address] = "#{params[:street]} #{params[:number]}, #{params[:apartment]}"
            super
          end

          api :PUT, '/v1/auth/users', "Update user"
          param :first_name, lambda { |val| true }, :desc => "Must be a string", required: false
          param :last_name, lambda { |val| true }, :desc => "Must be a string", required: false
          param :email, lambda { |val| true }, :desc => "Must be a string", required: false     
          param :telephone, lambda { |val| true }, :desc => "Must be a string", required: false
          param :picture, lambda { |val| true }, :desc => "Must be a file", required: false
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def update
            if (params[:picture].present? && params[:picture].is_a?(String) && params[:picture].start_with?("data:image/jpeg;base64"))
              params[:picture], tempfile = ImageParserService.parse_image_data(params[:picture]) 
            end
            super
            ImageParserService.clean_tempfile(tempfile)
          end

          api :POST, '/v1/auth/users/sign_up_with_facebook', "Create user with facebook"
          param :facebook_uid, String, required: true      
          param :first_name, String, required: true      
          param :last_name, String, required: true      
          param :email, String, required: true      
          param :picture, String, required: true  
          error :code => 401, :desc => "Unauthorized"
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']          
          def create_with_facebook
            @resource = User.where(facebook_uid: params[:facebook_uid]).first
            unless @resource.present? 
              password = SecureRandom.hex(8)
              @resource = User.new(facebook_uid: params[:facebook_uid],
                              first_name: params[:first_name],
                              last_name: params[:last_name],
                              email: params[:email],
                              remote_picture_url: params[:picture],
                              password: password,
                              password_confirmation: password)
            end

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
            else
              logger.info "Resource errors: #{@resource.errors.try(:to_json)}"
              render_create_error
            end
          end


          private

            def render_update_success
              render json: {status: 'success', data: UserSerializer.new(@resource).to_hash}, status: :ok 
            end

            def sign_up_params
              params.permit(:name, :email, :street, :address, :number, :apartment, :town, :town_id,
                            :height, :age, :password, :password_confirmation)
            end 

            def account_update_params
              params.permit(:first_name, :last_name, :telephone, :email, :picture, 
                            :dni, :state, :city, :locality, :address_street,
                            :address_number, :address_floor, :address_apartment,
                            :cuit, :password, :password_confirmation)
            end

            def render_create_error
              render json: {message: "could not create user"}, status: :unprocessable_entity
            end

        end
      end
    end
  end
end
