
FactoryBot.define do
    factory :chat do
        title { 'chat title' }
        user_id { 1 }
        private { false }
    end
end