
FactoryBot.define do
    factory :message do
        user_id { 1 }
        chat_id { 1 }
        body { 'Hello everyone' }
    end
end