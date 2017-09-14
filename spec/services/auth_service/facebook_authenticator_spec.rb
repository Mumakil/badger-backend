require 'rails_helper'

RSpec.describe AuthService::FacebookAuthenticator, type: :model do
  describe 'running' do
    let(:access_token) { SecureRandom.urlsafe_base64 }

    fake_api = nil

    before :each do
      fake_api = instance_double('FacebookAPI')
      expect(FacebookAPI).to receive(:new).with(access_token).and_return(fake_api)
    end

    it 'returns facebook auth data' do
      expect(fake_api).to receive(:me).and_return(
        'id' => 'fbid',
        'name' => 'fbuser'
      )
      expect(subject.call(access_token)).to eql(
        fbid: 'fbid',
        name: 'fbuser',
        avatar_url: FacebookAPI.avatar_url('fbid')
      )
    end

    it 'returns error on failure' do
      expect(fake_api).to receive(:me) do
        raise FacebookAPI::ApiError, 'something went wrong'
      end
      expect do
        subject.call(access_token)
      end.to raise_error(AuthService::AuthenticationFailed)
    end
  end
end
