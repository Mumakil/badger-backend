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

  describe 'code creation' do
    it 'creates a code when initializing group' do
      subject = Group.new
      code = subject.code
      expect(code).to be_a(String)
      expect(code.length).to be Group::CODE_LENGTH
    end

    it 'does not change code when reloading' do
      subject = FactoryGirl.create(:group)
      expect(subject.code).to eql(subject.reload.code)
    end
  end

  describe 'members' do
    let(:creator) { FactoryGirl.create(:user) }
    subject { FactoryGirl.create(:group, creator: creator) }

    it 'adds creator as member' do
      expect(subject.users.include?(creator)).to be true
    end

    it 'does not add same person twice' do
      expect(subject.users.size).to be 1
      expect do
        subject.users << subject.users.first
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
