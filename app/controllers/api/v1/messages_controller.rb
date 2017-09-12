module Api
  module V1
    class MessagesController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

      api :PUT, '/v1/messages/:id/read', "Mark message as read"
      error :code => 401, :desc => "Unauthorized"
      error :code => 404, :desc => "Page Not Found"
      error :code => 422, :desc => "Unprocessable Entity"
      formats ['json']
      def read
        message = Message.find(params[:id])
        if message.present?
          message.read = true
          message.viewed = true
          if message.save
            render json: message, status: :ok
          else
            render json: {message: "could mark as read this message"}, status: :unprocessable_entity
          end
        else
          render json: {message: "could not find message"}, status: :unprocessable_entity
        end
      end

      api :PUT, '/v1/messages/:id/view', "Mark message as viewed"
      error :code => 401, :desc => "Unauthorized"
      error :code => 404, :desc => "Page Not Found"
      error :code => 422, :desc => "Unprocessable Entity"
      formats ['json']
      def view
        message = Message.find(params[:id])
        if message.present?
          message.viewed = true
          if message.save
            render json: message, status: :ok
          else
            render json: {message: "could mark as viewed this message"}, status: :unprocessable_entity
          end
        else
          render json: {message: "could not find message"}, status: :unprocessable_entity
        end
      end

    end
  end
end
