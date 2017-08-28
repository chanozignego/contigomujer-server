module Api
  module Auth
    class PasswordsController < DeviseTokenAuth::PasswordsController
      include DeviseTokenAuth::Concerns::SetUserByToken
      
      protect_from_forgery with: :null_session

      devise_token_auth_group :member, contains: [:user, :carrier]

      def create #recover
        resource = resource_class.where(email: params[:email]).first
        if params[:email].present? && resource.present?
          resource.send_reset_password_instructions
          render json: resource, status: :ok
        else
          render json: {message: "could not find user"}, 
                        status: :unprocessable_entity
        end
      end

      def update #reset
        resource = resource_class.where(reset_password_token: params[:code]).first
        if params[:code].present? && resource.present?
          resource.password = params[:password]
          resource.password_confirmation = params[:password_confirmation]
          if resource.save
            render json: resource, status: :ok
          else
            render json: {message: "could not update user", resource: resource}, 
                          status: :unprocessable_entity
          end
        else
          render json: {message: "invalid reset password code"}, 
                        status: :unprocessable_entity
        end
      end

      def change
        authenticate_member!
        resource = current_member
        if params[:current_password].present? && resource.valid_password?(params[:current_password])
          resource.password = params[:password]
          resource.password_confirmation = params[:password_confirmation]
          if resource.save
            render json: resource, status: :ok
          else
            render json: {message: "could not update user", resource: resource}, 
                          status: :unprocessable_entity
          end
        else
          render json: {message: "invalid passwords"}, 
                        status: :unprocessable_entity
        end
      end

      # ParamError is superclass of ParamMissing, ParamInvalid
      rescue_from Apipie::ParamError do |e|
        render json: e.message, status: 400
      end
    
    end
  end
end
