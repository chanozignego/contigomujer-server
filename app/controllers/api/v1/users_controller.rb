module Api
  module V1
    class UsersController < Api::V1::ApplicationController

      devise_token_auth_group :member, contains: []

      api :GET, '/v1/users/:id/messages', "Get all messages of one user"
      param :id, :number, required: true      
      error :code => 401, :desc => "Unauthorized"
      error :code => 404, :desc => "Page Not Found"
      error :code => 422, :desc => "Unprocessable Entity"
      formats ['json']
      def messages
        if User.find(params[:id]).present?
          messages = Message.user.where(receiver_id: params[:id]).order(id: :desc)
          render json: messages, status: :ok
        else
          render json: {message: "could not find user"}, status: :unprocessable_entity
        end
      end

      def mark_messages_as_viewed
        if User.find(params[:id]).present?
          messages = Message.user.where(receiver_id: params[:id], viewed: false)
          messages.each do |mess| 
            mess.viewed = true
            mess.save!
          end
          render json: true, status: :ok
        else
          render json: {message: "could not find user"}, status: :unprocessable_entity
        end
      end

    end
  end
end
