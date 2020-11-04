module Api
  module V1
    class AdminsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_and_load_user
      before_action :check_if_admin, only: [:index, :show, :update]
    
      # GET api/v1/manage_users
      def index
        @users = User.all
        render json: {
          messages: "Request Successfull!",
          is_success: true,
          data: { users: @users }
        }
      end

      # GET api/v1/manage_users/[user_id]
      def show
        @user = User.find(params[:id])
        render json: {
          messages: "Request Successfull!",
          is_success: true,
          data: { user: @user }
        }
      end

      # PUT api/v1/manage_users/[user_id]
      def update
        user_params = params.require(:user).permit(:email, :username, :blocked)
        @user = User.find(params[:id])
        respond_to do |format|
          if @user.update(user_params)
            format.json { render json: {
              messages: "Request Successfull!",
              is_success: true,
              data: { user: @user }
            } }
          else
            format.json { render json: {
              messages: "Bad Request!",
              is_success: false,
              data: { }
            } }
          end
        end
      end

      # GET api/v1/manage_users
      def index_chats
        @chats = Chat.all
        render json: {
          messages: "Request Successfull!",
          is_success: true,
          data: { chats: @chats }
        }
      end

      # GET api/v1/manage_chats/[chat_id]
      def show_chat
        @chat = Chat.find(params[:id])
        render json: {
          messages: "Request Successfull!",
          is_success: true,
          data: { user: @chat }
        }
      end

      # PUT api/v1/manage_chats/[chat_id]
      def update_chat
        chat_params = params.require(:chat).permit(:title, :private, :closed)
        @chat = Chat.find(params[:id])
        respond_to do |format|
          if @chat.update(chat_params)
            format.json { render json: {
              messages: "Request Successfull!",
              is_success: true,
              data: { chat: @chat }
            } }
          else
            format.json { render json: {
              messages: "Bad Request!",
              is_success: false,
              data: { }
            } }
          end
        end
      end

      ############## CRUD MENSAJES #################

      # PUT api/v1/manage_messages/[message_id]

      # def censor_message
      #   message_params = params.require(:message).permit(:body)
      #   @message = Message.find(params[:id])
      #   respond_to do |format|
      #     if @message.update(censored: true)
      #       @censored_message = Censoredmessage.new(user_id: @current_user.id, message_id: @message.id, body: message_params["body"])
      #       if @censored_message.save
      #         format.json { render json: {
      #           messages: "Request Successfull!",
      #           is_success: true,
      #           data: { message: @message }
      #         } }
      #       else
      #         format.json { render json: {
      #           messages: "Bad Request!",
      #           is_success: false,
      #           data: { }
      #         } }
      #       end
            
      #     else
      #       format.json { render json: {
      #         messages: "Bad Request!",
      #         is_success: false,
      #         data: { }
      #       } }
      #     end
      #   end
      # end



      private
      # Use callbacks to share common setup or constraints between actions.

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

      def check_if_admin
        return if @current_user.admin
        render json: {
            messages: "User is not admin",
            is_success: false,
            data: {}
          }, status: :bad_request
      end
    end
  end
end