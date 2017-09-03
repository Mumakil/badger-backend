require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'yields valid users with full data' do
      expect(User.new(
        name: 'foo',
        fbid: 'bar',
        avatar_url: 'http://example.com/avatar'
      )).to be_valid
    end

    it 'creates valid users with factory' do
      expect(build(:user)).to be_valid
    end
  end
end
