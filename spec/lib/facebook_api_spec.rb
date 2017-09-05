require 'rails_helper'
require 'facebook_api'

RSpec.describe FacebookAPI, type: :model do
  describe 'basic request' do
    let(:access_token) { SecureRandom.urlsafe_base64 }
    let(:client) { FacebookAPI.new(access_token) }

    it 'handles faraday errors' do
      connection = instance_double('Faraday::Connection')
      allow(connection).to receive(:get) do
        raise Faraday::ClientError::ConnectionFailed, 'failed connection'
      end
      client.instance_variable_set :@client, connection
      expect do
        client.me
      end.to raise_error(FacebookAPI::ConnectionError, 'failed connection')
    end

    it 'handles facebook errors' do
      stub_request(:get, 'https://graph.facebook.com/me?fields=id,name')
        .with(headers: { 'Authorization' => "Bearer #{access_token}" })
        .to_return(
          status: 403,
          body: '{"error":{"message":"error message"}}',
          headers: { 'Content-Type' => 'application/json' }
        )
      expect do
        client.me
      end.to raise_error(FacebookAPI::ApiError, 'error message')
    end

    it 'returns response data' do
      stub_request(:get, 'https://graph.facebook.com/me?fields=id,name')
        .with(headers: { 'Authorization' => "Bearer #{access_token}" })
        .to_return(
          status: 200,
          body: '{"id":"123","name":"Example person"}',
          headers: { 'Content-Type' => 'application/json' }
        )
      expect(client.me).to match('id' => '123', 'name' => 'Example person')
    end
  end
end
