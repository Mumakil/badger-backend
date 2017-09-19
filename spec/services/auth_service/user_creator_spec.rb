require 'rails_helper'

RSpec.describe AuthService::UserCreator, type: :model do
  describe 'running' do
    let(:fbid) { FactoryGirl.generate(:fbid) }
    let(:avatar_url) { FactoryGirl.generate(:avatar_url) }
    let(:user_data) do
      {
        fbid: fbid, name:
        FactoryGirl.generate(:user_name),
        avatar_url: avatar_url
      }
    end

    it 'creates user if it does not exist' do
      expect do
        user = subject.call(user_data)
        expect(user.name).to eql(user_data[:name])
        expect(user.fbid).to eql(user_data[:fbid])
      end.to change(User, :count).by(1)
    end

    it 'updates existing user' do
      existing_user = create(:user, fbid: fbid)
      expect do
        user = subject.call(user_data)
        expect(user.id).to eql(existing_user.id)
        expect(user.name).to eql(user_data[:name])
        expect(user.avatar_url).to eql(user_data[:avatar_url])
      end.not_to change(User, :count)
    end
  end
end
