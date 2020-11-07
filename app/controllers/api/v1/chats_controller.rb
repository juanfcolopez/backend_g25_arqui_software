module Api
    module V1
        class ChatsController < ApplicationController
            protect_from_forgery with: :null_session
            before_action :set_chat, only: [:show, :edit, :update, :destroy, :associate]
            before_action :check_if_open, only: [:show]
            before_action :authenticate_and_load_user
            before_action :authenticate_member, only: [:show]
          
            # GET /chats
            # GET /chats.json
            def associate
                your_requests = Member.where(user_id: @current_user.id)
                your_request_ids = []
                your_requests.each {|req|
                    your_request_ids << req.chat_id
                }
                if your_request_ids.include?(@chat.id)
                    render json: {
                        messages: "You already sent a request!",
                        is_success: false,
                        data: { }
                    }
                elsif Member.new(user_id: @current_user.id, chat_id: @chat.id).save
                    render json: {
                        messages: "User associated!",
                        is_success: true,
                        data: { chat_id: @chat.id, user_id: @current_user.id }
                    }
                else
                    render json: {
                        messages: "User cannot associate to this channel!",
                        is_success: false,
                        data: { }
                    }
                end

            end

            def index
              all_chats = Chat.where(closed: false)
              chats_response = []
              permitted_requests = Member.where(user_id: @current_user.id, valid_flag: true)
              permitted_chat_rooms = []
              permitted_requests.each { |req|
                permitted_chat_rooms << req.chat_id
              }
              chats = Chat.where(private: false).or(Chat.where(id: permitted_chat_rooms))
              all_chats.each { |chat|
                chat_copy = chat.attributes
                if chats.include?(chat)
                    chat_copy[:permission] = true
                else
                    chat_copy[:permission] = false
                end
                chats_response << chat_copy
              }
              render json: {
                  messages: "Request Successfull!",
                  is_success: true,
                  data: { chats: chats_response }
              }
            end

            # POST api/v1/chats
            # body de request: chat[title]

            def create
                @chat = Chat.new(chat_params)
                @chat.user_id = @current_user.id
                respond_to do |format|
                    if @chat.save
                        Member.new(chat_id: @chat.id, user_id: @current_user.id, valid_flag: true).save
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

            # GET api/v1/chats/[chat_id]

            def show
                @messages = @chat.messages
                messages_copy = []
                @messages.each { |message|
                    message_copy = message.attributes
                    username = User.find(message.user_id).username
                    message_copy[:username] = username
                    if message.censored
                        message_copy[:censored_message] = Censoredmessage.where(message_id: message.id).last
                    end
                    messages_copy << message_copy
                }
                render json: {
                    messages: "Request Successfull!",
                    is_success: true,
                    data: { owner: @chat.user.username, messages: messages_copy }
                }
            end
          
            private

            def authenticate_member
                permission = Member.where(chat_id: @chat.id, user_id: @current_user.id)
                if !@chat[:private]
                    return true
                elsif permission.length == 0
                    render json: {
                        messages: "You dont have the permissions to see that chat",
                        is_success: false,
                        data: {}
                    }
                elsif permission[0].valid_flag
                    return true
                elsif @chat.user == @current_user
                    return true
                else
                    render json: {
                        messages: "You dont have the permissions to see that chat",
                        is_success: false,
                        data: {}
                    }
                end
            end

              # Use callbacks to share common setup or constraints between actions.
            def set_chat
                if params[:id]
                    @chat = Chat.find(params[:id])
                elsif params[:chat_id]
                    @chat = Chat.find(params[:chat_id])
                end
            end
        
            # Only allow a list of trusted parameters through.
            def chat_params
            params.require(:chat).permit(:title, :private)
            end

            def check_if_open
                return if !@chat.closed
                render json: {
                    messages: "Chat is closed",
                    is_success: false,
                    data: {}
                }, status: :bad_request
            end

            def authenticate_and_load_user
                authentication_token = nil
                if request.headers["Authorization"]
                    authentication_token = request.headers["Authorization"].split[1]
                end
                if authentication_token
                    user = JWT.decode(authentication_token, nil, false, algorithms: 'RS256')
                    username = user[0]["nickname"]
                    email = user[0]["name"]
                    @current_user = User.find_by(email: email, username: username)
                    if !@current_user.present?
                        user = User.new(email: email, username: username, password: '000000', password_confirmation: '000000')
                        if user.save
                            @current_user = user
                        end
                    end
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