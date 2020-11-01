
FactoryBot.define do
    factory :user do
        email { 'ejemplo@uc.cl' }
        password { 'password123P' }
        password_confirmation { 'password123P' }
        username {'Juan'}

    end
end
