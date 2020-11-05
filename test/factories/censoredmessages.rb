FactoryBot.define do
  factory :censoredmessage do
    message_id { "" }
    body { "MyText" }
    user_id { "" }
  end
end
