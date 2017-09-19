require 'rails_helper'

RSpec.describe Token, type: :model do
  describe 'encoding and decoding' do
    let(:user) { FactoryGirl.create(:user) }
    let(:token) { Token.new(user: user) }

    it 'encodes into jwt and decodes' do
      encoded = token.encode
      expect(encoded).to be_a(String)

      decoded = Token.decode(encoded)
      expect(decoded.user_id).to be user.id
    end
  end
end
