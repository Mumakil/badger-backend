require 'rails_helper'

RSpec.describe 'token creation', type: :request do
  let(:fake_api) { instance_double('FacebookAPI') }
  let(:access_token) { SecureRandom.urlsafe_base64 }
  let(:user_data) do
    {
      'id' => generate(:fbid),
      'name' => generate(:user_name)
    }
  end

  before :each do
    expect(FacebookAPI).to receive(:new).with(access_token).and_return(fake_api)
  end

  it 'creates a token for a user with a successful authentication' do
    expect do
      expect(fake_api).to receive(:me).and_return(user_data)
      post '/tokens', params: { access_token: access_token, strategy: 'facebook' }
      expect(response).to be_success
      expect(json_response[:token]).not_to be_blank
    end.to change(User, :count).by(1)
  end

  it 'renders an error with a failed authentication' do
    expect do
      expect(fake_api).to receive(:me) do
        raise FacebookAPI::ApiError, 'invalid token'
      end
      post '/tokens', params: { access_token: access_token, strategy: 'facebook' }
      expect(response).not_to be_success
      expect(json_response[:error]).not_to be_blank
    end.not_to change(User, :count)
  end
end
