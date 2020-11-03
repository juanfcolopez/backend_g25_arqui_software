module Api
    module V1
        class MembersController < ApplicationController
            protect_from_forgery with: :null_session
            before_action :authenticate_and_load_user
            before_action :set_member_request, only: [:validate_request]

            def index
                chats = @current_user.chats
                chats_ids = []
                chats.each { |chat|
                    chats_ids << chat.id
                }
                member_requests = Member.where(chat_id: chats_ids)
                respond_copy = []
                member_requests.each {|req|
                    a = req.attributes
                    a[:username] = req.user.username
                    a[:title] = req.chat.title
                    respond_copy << a

                }
                render json: { 
                    message: 'Request Succesfull!',
                    is_success: true,
                    data: respond_copy
                }
    
            end

            def validate_request
                if @current_user.id == @member_request.chat.user.id
                    @member_request.valid_flag = true
                    @member_request.save
                    render json: { 
                        message: 'Member added!',
                        is_success: true,
                        data: {}
                    }
                else
                    render json: { 
                        message: 'You can not do that!',
                        is_success: false,
                        data: {}
                    }
                end
                
            end
             
          
            private

            def set_member_request
                if params[:id]
                    @member_request = Member.find(params[:id])
                elsif params[:member_id]
                    @member_request = Member.find(params[:member_id])
                end
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