require 'rails_helper'

RSpec.describe 'group endpoints', type: :request do
  context 'without authentication' do
    let(:group) { FactoryGirl.create(:group) }

    it 'requires authentication' do
      get "/groups/#{group.id}"
      expect(response).to have_http_status :unauthorized
      expect(json_response).not_to have_key :id
    end
  end

  context 'with authentication' do
    describe '#show' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group, creator: current_user) }
      let(:other_group) { FactoryGirl.create(:group) }

      before :each do
        login_user(current_user)
      end

      it 'shows a group current user is member of' do
        get "/groups/#{group.id}"
        expect(response).to be_success
        expect(json_response.deep_symbolize_keys).to eql(
          id: group.id,
          name: group.name,
          photo_url: group.photo_url,
          code: group.code,
          creator: {
            id: group.creator.id,
            name: group.creator.name,
            avatar_url: group.creator.avatar_url
          },
          members: [
            {
              id: group.creator.id,
              name: group.creator.name,
              avatar_url: group.creator.avatar_url
            }
          ]
        )
      end

      it 'does not show someone elses group' do
        get "/groups/#{other_group.id}"
        expect(response).to have_http_status :not_found
        expect(json_response).not_to have_key :id
      end

      it 'renders 404' do
        get "/groups/#{Random.rand(100_000_000)}"
        expect(response).to have_http_status :not_found
        expect(json_response).not_to have_key :id
      end
    end

    describe '#update' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }
      let(:valid_params) do
        {
          name: 'Example group',
          photo_url: FactoryGirl.generate(:photo_url)
        }
      end

      before :each do
        login_user(current_user)
      end

      it 'updates a group the user is member of' do
        group.members << current_user
        put "/groups/#{group.id}", params: valid_params
        expect(response).to be_success
        expect(json_response[:name]).to eql valid_params[:name]
        expect(json_response[:photo_url]).to eql valid_params[:photo_url]
      end

      it 'does not update a group user is not member of' do
        put "/groups/#{group.id}", params: valid_params
        expect(response).to have_http_status :not_found
      end
    end

    describe '#create' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:valid_params) do
        {
          name: 'Example group',
          photo_url: FactoryGirl.generate(:photo_url)
        }
      end

      before :each do
        login_user(current_user)
      end

      it 'render validation error' do
        post '/groups', params: { photo_url: FactoryGirl.generate(:photo_url) }
        expect(response).to have_http_status :bad_request
      end

      it 'creates the group' do
        post '/groups', params: valid_params
        expect(response).to have_http_status :created
        expect(json_response).to have_key :id
      end

      it 'adds the user as creator' do
        post '/groups', params: valid_params
        expect(json_response[:creator].symbolize_keys).to eql(
          id: current_user.id,
          name: current_user.name,
          avatar_url: current_user.avatar_url
        )
      end

      it 'adds the user as member' do
        post '/groups', params: valid_params
        expect(json_response[:members].size).to be 1
        expect(json_response[:members].first.symbolize_keys).to eql(
          id: current_user.id,
          name: current_user.name,
          avatar_url: current_user.avatar_url
        )
      end
    end
  end
end
