module Api
  module V1
    class MessagesController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_chat
      before_action :authenticate_and_load_user
      before_action :authenticate_member, only: [:create]

      def create
        @message = @chat.messages.new(message_params)
        @message.user = @current_user
        @message.save
        message_copy = @message.attributes
        message_copy[:username] = @current_user.username
        render json: {
          messages: "Request Successfull!",
          is_success: true,
          data: { message: message_copy }
        }
      end

      private
      
      def authenticate_member
        permission = Member.where(chat_id: @chat.id, user_id: @current_user.id)
        if !@chat[:private]
            return true
        elsif permission.length == 0
            render json: {
                messages: "You dont have the permissions to create a message in the chat",
                is_success: false,
                data: {}
            }
        elsif permission[0].valid_flag
            return true
        elsif @chat.user == @current_user
            return true
        else
            render json: {
                messages: "You dont have the permissions to create a message in the chat",
                is_success: false,
                data: {}
            }
        end
      end    

      def message_params
        params.require(:message).permit(:body, :chat_id)
      end

      def set_chat
        @chat = Chat.find(params[:chat_id])
      end

      def authenticate_and_load_user
        authentication_token = nil
        if request.headers["Authorization"]
            authentication_token = request.headers["Authorization"].split[1]
        end
        if authentication_token
            @current_user = User.find_by(auth_token: authentication_token)
        end
        return if @current_user.present?
        render json: {
            messages: "Can't authenticate user",
            is_success: false,
            data: {}
          }, status: :bad_request
      end

    end
  end
end