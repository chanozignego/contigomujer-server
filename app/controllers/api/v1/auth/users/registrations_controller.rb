module Api
  module V1
    module Auth
      module Users
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
            # if (params[:picture].present? && params[:picture].is_a?(String) && params[:picture].start_with?("data:image/jpeg;base64"))
            #   params[:picture], tempfile = ImageParserService.parse_image_data(params[:picture]) 
            # end
            # super
            # ImageParserService.clean_tempfile(tempfile)
            super
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
