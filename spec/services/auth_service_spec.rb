require 'rails_helper'

RSpec.describe AuthService, type: :model do
  describe 'running' do
    let(:authenticator) { instance_double('AuthService::FacebookAuthenticator') }
    let(:user_creator) { instance_double('AuthService::UserCreator') }
    let(:token_creator) { instance_double('AuthService::TokenCreator') }

    subject { AuthService.new(authenticator, user_creator, token_creator) }

    let(:access_token) { SecureRandom.urlsafe_base64 }
    let(:user_data) do
      {
        fbid: FactoryGirl.generate(:fbid),
        name: FactoryGirl.generate(:user_name),
        avatar_url: FactoryGirl.generate(:avatar_url)
      }
    end
    let(:user) { User.create!(user_data) }
    let(:token) { Token.new(user: user) }

    it 'runs successfully' do
      expect(authenticator).to receive(:call).with(access_token).and_return(user_data)
      expect(user_creator).to receive(:call).with(user_data).and_return(user)
      expect(token_creator).to receive(:call).with(user).and_return(token)
      result = subject.call(access_token: access_token)
      expect(result.token).to be(token)
    end

    it 'returns an error when there is failure' do
      expect(authenticator).to receive(:call).with(access_token) do
        raise AuthService::AuthenticationFailed, 'wrong credentials'
      end
      expect do
        subject.call(access_token: access_token)
      end.to raise_error(AuthService::AuthenticationFailed)
    end
  end
end
