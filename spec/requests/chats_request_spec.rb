require 'rails_helper'

RSpec.describe "Chats", type: :request do
    let(:user) { FactoryBot.create(:user) }

    describe "Post /sign_up" do 
        let(:user_params) do 
            {
                "user": 
                {
                    email: 'ejemplo@uc.cl', 
                    password: 'password123P', 
                    password_confirmation: 'password123P', 
                    username: 'Juan'
                }
            }
        end
        it "return http success" do 
            post "/api/v1/sign_up", params: user_params
            expect(response).to have_http_status(:success)
        end
    end 
end