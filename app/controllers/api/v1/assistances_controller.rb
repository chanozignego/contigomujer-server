module Api
  module V1
    class AssistancesController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

      def cancel
        assistance = Assistance.find(params[:id])
        assistance.state = :canceled
        if assistance.save
          # TODO: notify adminuser
          render json: assistance, status: :ok
        else
          render json: {message: "could not update assistance", resource: assistance}, 
                        status: :unprocessable_entity
        end
      end



    end
  end
end
