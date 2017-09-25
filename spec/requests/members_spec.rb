require 'rails_helper'

RSpec.describe 'member endpoints', type: :request do
  context 'without authentication' do
    let(:group) { FactoryGirl.create(:group) }

    it 'requires authentication' do
      get "/groups/#{group.id}/members"
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'with authentication' do
    describe '#create' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }

      before :each do
        login_user(current_user)
      end

      it 'adds current user as member' do
        post '/memberships', params: { code: group.code }
        expect(response).to have_http_status :created
        expect(json_response[:group][:id]).to eql group[:id]
      end

      it 'fails with invalid code' do
        post '/memberships', params: { code: SecureRandom.urlsafe_base64 }
        expect(response).to have_http_status :not_found
      end
      it 'fails if user is already a member' do
        group.members << current_user
        post '/memberships', params: { code: group.code }
        expect(response).to have_http_status :bad_request
      end
    end

    describe '#destroy' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }

      before :each do
        login_user(current_user)
      end

      it 'removes the user successfully' do
        group.members << current_user
        delete "/groups/#{group.id}/members/#{current_user.id}"
        expect(response).to be_success
        expect(group.members.reload.include?(current_user)).to be false
      end

      it 'does not remove someone else' do
        group.members << other_user
        delete "/groups/#{group.id}/members/#{other_user.id}"
        expect(response).not_to be_success
      end

      it 'fails if user is not a member' do
        delete "/groups/#{group.id}/members/#{current_user.id}"
        expect(response).not_to be_success
      end
    end

    describe '#index' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:other_users) { FactoryGirl.create_list(:user, 3) }
      let(:group) { FactoryGirl.create(:group, members: other_users << current_user) }
      let(:other_group) { FactoryGirl.create(:group) }

      before :each do
        login_user(current_user)
      end

      it 'lists the members when part of the group' do
        get "/groups/#{group.id}/members"
        expect(response).to be_success
        expect(json_response.size).to be other_users.size + 1
        expect(json_response.map { |m| m[:id] }.sort).to eql group.members.reload.sort.map(&:id)
      end

      it 'does not list members when not part of group' do
        get "/groups/#{other_group.id}/members"
        expect(response).to have_http_status :not_found
      end
    end
  end
end
