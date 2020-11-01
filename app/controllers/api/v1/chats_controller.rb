module Api
    module V1
        class ChatsController < ApplicationController
            protect_from_forgery with: :null_session
            before_action :set_chat, only: [:show, :edit, :update, :destroy]
            before_action :authenticate_and_load_user
          
            # GET /chats
            # GET /chats.json
            def index
              @chats = Chat.all
              render json: {
                  messages: "Request Successfull!",
                  is_success: true,
                  data: { chats: @chats }
              }
            end

            def create
                @chat = Chat.new(chat_params)

                respond_to do |format|
                    if @chat.save
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

            def show
                @messages = @chat.messages
                messages_copy = []
                @messages.each { |message|
                    message_copy = message.attributes
                    username = User.find(message.user_id).username
                    message_copy[:username] = username
                    messages_copy << message_copy
                }
                render json: {
                    messages: "Request Successfull!",
                    is_success: true,
                    data: { messages: messages_copy }
                }
            end
          
            private
              # Use callbacks to share common setup or constraints between actions.
              def set_chat
                @chat = Chat.find(params[:id])
              end
          
              # Only allow a list of trusted parameters through.
              def chat_params
                params.require(:chat).permit(:title)
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