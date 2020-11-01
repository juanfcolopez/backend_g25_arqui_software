module Api
  module V1
    class SessionsController < Devise::SessionsController
      protect_from_forgery with: :null_session
      before_action :sign_in_params, only: :create
      before_action :load_user, only: :create
      
      # sign in
      def create
        if @user.valid_password?(sign_in_params[:password])
          render json: {
            messages: "Signed In Successfully",
            is_success: true,
            data: {user: @user}
          }, status: :ok
        else
          render json: {
            messages: "Signed In Failed - Unauthorized",
            is_success: false,
            data: {}
          }, status: :unauthorized
        end
      end

      private
      def sign_in_params
        params.require(:sign_in).permit :email, :password
      end

      def load_user
        @user = User.find_for_database_authentication(email: sign_in_params[:email])
        if @user
          return @user
        else
          render json: {
            messages: "Cannot get User",
            is_success: false,
            data: {}
          }, status: :bad_request
        end
      end
    end
  end
end