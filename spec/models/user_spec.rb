require 'rails_helper'

RSpec.describe User, type: :model do
    it 'has many messages' do
      user_msg_association = User.reflect_on_association(:messages)
      expect(user_msg_association.macro).to eq(:has_many)
    end

    it 'has many chats' do
      user_chat_association = User.reflect_on_association(:chats)
      expect(user_chat_association.macro).to eq(:has_many)
    end
    it 'has invalid create user without email' do
        expect(build(:user, email: nil)).not_to be_valid
    end
end