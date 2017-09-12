module Api
  module V1
    class AssistancesController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

      def cancel
        assistance = Assistance.find(params[:id])
        assistance.state = :canceled
        if assistance.save
          auxiliary = Auxiliary.where(admin_user: assistance.admin_user).first
          NotificationManager.notificate_assistance_canceled(assistance, auxiliary)
          render json: assistance, status: :ok
        else
          render json: {message: "could not update assistance", resource: assistance}, 
                        status: :unprocessable_entity
        end
      end

      def accept
        assistance = Assistance.find(params[:id])
        assistance.state = :accepted
        assistance.minutes = params[:minutes]
        assistance.admin_user = Auxiliary.find(params[:auxiliary_id]).admin_user
        if assistance.save
          # TODO: notify adminuser
          render json: assistance, status: :ok
        else
          render json: {message: "could not update assistance", resource: assistance}, 
                        status: :unprocessable_entity
        end
      end

      private 

        def render_create_success resource
          auxiliaries = Auxiliary.where(town: resource.town)
          auxiliaries.each do |aux|
            NotificationManager.notificate_request_assistance(resource, aux)
          end

          super
        end

    end
  end
end
