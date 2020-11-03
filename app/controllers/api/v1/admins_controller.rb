module Api
  module V1
    class AdminsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_user, only: [:show, :edit, :update]
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
        render json: {
          messages: "Request Successfull!",
          is_success: true,
          data: { user: @user }
        }
      end

      # PUT api/v1/manage_users/[user_id]
      def update
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

      # PUT api/v1/manage_users/delete/[user_id]
      # no funciona porque id de user es foreign key en tablas chats y messages
      # def destroy
      #   respond_to do |format|
      #     if @user.update(blocked: true)
      #       format.json { render json: {
      #         messages: "Request Successfull!",
      #         is_success: true,
      #         data: { user: @user }
      #       } }
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
      def set_user
        @user = User.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:email, :username, :blocked)
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