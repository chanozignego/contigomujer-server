module Api
  module Auth
    class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
      protect_from_forgery with: :null_session, only: :create

      # ParamError is superclass of ParamMissing, ParamInvalid
      rescue_from Apipie::ParamError do |e|
        render json: e.message, status: 400
      end

    end
  end
end
