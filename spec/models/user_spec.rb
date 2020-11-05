require 'rails_helper'

RSpec.describe User, type: :model do
    it 'has invalid factory without name' do
      expect(build(:user, username: nil)).not_to be_valid
    end

    it 'has invalid factory without name' do
        expect(build(:user, email: nil)).not_to be_valid
    end
end