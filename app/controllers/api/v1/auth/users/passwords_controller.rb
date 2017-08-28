module Api
  module V1
    module Auth
      module Users
        class PasswordsController < Api::Auth::PasswordsController

          resource_description do
            name "Users/Passwords"
          end

          api :POST, '/v1/auth/users/password', "Recover user password. Send recover instructions"
          param :email, String, required: true      
          error :code => 401, :desc => "Unauthorized"
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']
          def create #recover
            super
          end

          api :PUT, '/v1/auth/users/password', "Reset user password. Update password"
          param :code, String, required: true
          param :password, String, required: true
          param :password_confirmation, String, required: true
          error :code => 401, :desc => "Unauthorized"
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']
          def update #reset
            super
          end

          api :PUT, '/v1/auth/users/password/change', "Change user password"
          param :current_password, String, required: true
          param :password, String, required: true
          param :password_confirmation, String, required: true
          error :code => 401, :desc => "Unauthorized"
          error :code => 404, :desc => "Page Not Found"
          error :code => 422, :desc => "Unprocessable Entity"
          formats ['json']
          def change
            super
          end


        end
      end
    end
  end
end
