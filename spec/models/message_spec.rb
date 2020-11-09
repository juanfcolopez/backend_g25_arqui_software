require 'rails_helper'

RSpec.describe Message, type: :model do
    let(:usermsg) { FactoryBot.create(:user, auth_token: 'Token_test2') }
    let(:chat) { FactoryBot.create(:chat) }
    it 'belongs_to messages' do
      msg_user_association = Message.reflect_on_association(:user)
      expect(msg_user_association.macro).to eq(:belongs_to)
    end

    it 'belongs_to chats' do
      msg_chat_association = Message.reflect_on_association(:chat)
      expect(msg_chat_association.macro).to eq(:belongs_to)
    end
    
    it 'has invalid create message without user_id' do
        expect(build(:message, user_id: nil)).not_to be_valid
    end

    it 'has invalid create message without chat_id' do
        expect(build(:message, chat_id: nil)).not_to be_valid
    end

    it 'has valid create message with all parameters ' do
        expect(build(:message, user_id: usermsg.id, chat_id: chat.id)).to be_valid
    end
end