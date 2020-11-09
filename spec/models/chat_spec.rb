require 'rails_helper'

RSpec.describe Chat, type: :model do
    let(:user) { FactoryBot.create(:user) }
    it 'has_many messages' do
      chat_msgs_association = Chat.reflect_on_association(:messages)
      expect(chat_msgs_association.macro).to eq(:has_many)
    end

    it 'belongs_to user' do
      chat_user_association = Chat.reflect_on_association(:user)
      expect(chat_user_association.macro).to eq(:belongs_to)
    end
    
    it 'has invalid chat without user_id' do
        expect(build(:chat, user_id: nil)).not_to be_valid
    end

    it 'has valid create chat with all parameters ' do
        expect(build(:chat, user_id: user.id)).to be_valid
    end
end