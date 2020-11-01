module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :ensure_params_exist, only: :create
      skip_before_action :verify_authenticity_token, :only => :create
      # sign up
      def create
        user = User.new user_params
        user.auth_token = generate_token
        if user.save
          render json: {
            messages: "Sign Up Successfully",
            is_success: true,
            data: {user: user}
          }, status: :ok
        else
          render json: {
            messages: "Sign Up Failded",
            is_success: false,
            data: {}
          }, status: :unprocessable_entity
        end
      end
    
      private
      def user_params
        params.require(:user).permit(:email, :password, :username, :password_confirmation)
      end
    
      def ensure_params_exist
        return if params[:user].present?
        render json: {
            messages: "Missing Params",
            is_success: false,
            data: {}
          }, status: :bad_request
      end

      def generate_token
        token = loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless User.exists?(auth_token: random_token)
        end
        return token
      end

    end
  end
end