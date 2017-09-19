require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validation' do
    let(:creator) { FactoryGirl.create(:user) }

    it 'yields valid groups with full data' do
      expect(Group.new(
        name: 'My group',
        photo_url: 'http://example.com/photo',
        creator: creator
      )).to be_valid
    end

    it 'creates valid groups with factory' do
      expect(FactoryGirl.build(:group)).to be_valid
    end
  end
end
