require 'rails_helper'

RSpec.describe 'user endpoints', type: :request do
  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:current_user) { FactoryGirl.create(:user) }

    context 'without authentication' do
      it 'requires authentication' do
        get "/users/#{user.id}"
        expect(response).to have_http_status :unauthorized
        expect(json_response).not_to have_key :id
      end
    end

    context 'with authentication' do
      before :each do
        login_user(current_user)
      end

      it 'shows me' do
        get '/users/me'
        expect(response).to be_success
        expect(json_response[:id]).to be current_user.id
      end

      it 'shows me by id' do
        get "/users/#{current_user.id}"
        expect(response).to be_success
        expect(json_response.symbolize_keys).to eql(
          id: current_user.id,
          name: current_user.name,
          avatar_url: current_user.avatar_url,
          fbid: current_user.fbid,
          created_at: current_user.created_at.iso8601,
          updated_at: current_user.updated_at.iso8601
        )
      end

      it 'shows someone else' do
        get "/users/#{user.id}"
        expect(response).to be_success
        expect(json_response.symbolize_keys).to eql(
          id: user.id,
          name: user.name,
          avatar_url: user.avatar_url
        )
      end

      it 'renders 404' do
        get "/users/#{Random.rand(100_000_000)}"
        expect(response).to have_http_status :not_found
        expect(json_response).not_to have_key :id
      end
    end
  end
end
